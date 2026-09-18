// aicodemetrics opencode plugin — do not edit (managed by aicodemetricsd)
import { spawn } from "node:child_process";

const BINARY_PATH = "/usr/local/bin/aicodemetricsd";

// Tools that only read or search a file, or track session state. Their calls are
// not reported; every other tool's calls are.
const IGNORED_TOOLS = new Set([
  "read",
  "list",
  "glob",
  "grep",
  "lsp",
  "webfetch",
  "websearch",
  "skill",
  "todowrite",
  "todoread",
  "task",
  "question",
  "plan_exit",
  "invalid",
]);

function isReportedTool(tool) {
  return typeof tool === "string" && !IGNORED_TOOLS.has(tool.toLowerCase());
}

// Cap on cached sessions, so a long-running server does not accumulate entries.
const MAX_TRACKED_SESSIONS = 256;

// sessionID → {version, model, versionKnown}, filled in from the event stream
// so a tool call never has to look up the session it belongs to. versionKnown
// marks a version as resolved, which an empty version alone does not: a failed
// lookup caches as empty, while an entry that has only seen a model retries.
const sessionCache = new Map();

// In-flight version lookups, so concurrent cache misses share one request.
const pendingLookups = new Map();

// Merges the supplied fields into a session's entry. Empty values never
// overwrite a value already recorded.
function cacheSessionData(sessionID, fields) {
  if (!sessionID) return;
  const entry = sessionCache.get(sessionID) ?? {
    version: "",
    model: "",
    versionKnown: false,
  };
  if (fields.version) entry.version = fields.version;
  if (fields.model) entry.model = fields.model;
  if (fields.versionKnown) entry.versionKnown = true;
  // Re-insert so the eviction below drops the least recently updated session.
  sessionCache.delete(sessionID);
  sessionCache.set(sessionID, entry);
  while (sessionCache.size > MAX_TRACKED_SESSIONS) {
    const coldest = sessionCache.keys().next();
    if (coldest.done) break;
    sessionCache.delete(coldest.value);
  }
}

// Cap on how long a tool call waits for a report to be delivered.
const HOOK_TIMEOUT_MS = 3000;

// Sends a payload and resolves once delivery finishes, times out, or cannot be
// started. Never rejects, so an ignored result cannot raise an unhandled
// rejection. Callers that need delivery to finish before the work they precede
// await the result; the rest let it run on its own.
function sendToHook(payload) {
  return new Promise((resolve) => {
    let child;
    try {
      child = spawn(
        BINARY_PATH,
        ["hook", "opencode", "--hook-input", "stdin"],
        {
          stdio: ["pipe", "ignore", "ignore"],
        },
      );
    } catch {
      // Ignore errors so telemetry never disrupts the user's session.
      resolve();
      return;
    }
    // The first of exit / error / timeout resolves; the rest are no-ops.
    const timer = setTimeout(() => resolve(), HOOK_TIMEOUT_MS);
    timer.unref?.(); // do not hold the event loop open
    const finish = () => {
      clearTimeout(timer);
      resolve();
    };
    child.on("exit", finish);
    child.on("error", finish);
    child.stdin.on("error", () => {});
    child.stdin.end(payload);
  });
}

// Returns the tool version and model recorded for a session. A resolved version
// comes from the cache; otherwise one lookup supplies it and is cached even
// when it fails, so a session costs at most one request. The model stays empty
// until the session's first assistant message arrives.
async function getSessionData(client, sessionID) {
  if (!sessionID) return { version: "", model: "" };

  const cached = sessionCache.get(sessionID);
  if (cached?.versionKnown) {
    return { version: cached.version, model: cached.model };
  }

  let lookup = pendingLookups.get(sessionID);
  if (!lookup) {
    lookup = client.session
      .get({ path: { id: sessionID } })
      .then((resp) => resp?.data?.version ?? "")
      .catch(() => "")
      .finally(() => pendingLookups.delete(sessionID));
    pendingLookups.set(sessionID, lookup);
  }

  const version = await lookup;
  cacheSessionData(sessionID, { version, versionKnown: true });
  const entry = sessionCache.get(sessionID);
  return { version: entry?.version ?? version, model: entry?.model ?? "" };
}

export const AiCodeMetricsPlugin = async ({ client, directory }) => ({
  event: async ({ event }) => {
    // An assistant message carries the model that runs the turn's tool calls.
    if (event.type === "message.updated") {
      const info = event.properties?.info;
      if (info?.role === "assistant") {
        cacheSessionData(info.sessionID, { model: info.modelID });
      }
      return;
    }

    if (event.type === "session.deleted") {
      const deletedID =
        event.properties?.info?.id ?? event.properties?.sessionID;
      if (deletedID) sessionCache.delete(deletedID);
      return;
    }

    if (event.type === "session.created") {
      // The event usually carries the whole session; fetch it if not.
      let session = event.properties?.info;
      const sessionID = session?.id ?? event.properties?.sessionID;
      if (!sessionID) return;
      try {
        if (!session) {
          const sessionResp = await client.session.get({
            path: { id: sessionID },
          });
          session = sessionResp?.data;
        }
        if (!session) return;
        // Cache before the parent check: child sessions run tools too.
        cacheSessionData(sessionID, {
          version: session.version,
          versionKnown: true,
        });
        if (session.parentID) return;
        sendToHook(
          JSON.stringify({
            event_type: "session",
            lifecycle: "start",
            session,
            directory,
          }),
        );
      } catch {
        // Ignore errors so telemetry never disrupts the user's session.
      }
      return;
    }

    if (event.type !== "session.idle" && event.type !== "session.compacted")
      return;
    const sessionID = event.properties?.sessionID;
    if (!sessionID) return;

    try {
      const sessionResp = await client.session.get({ path: { id: sessionID } });
      const session = sessionResp?.data;
      if (!session) return;
      cacheSessionData(sessionID, {
        version: session.version,
        versionKnown: true,
      });
      if (session.parentID) return;

      const messagesResp = await client.session.messages({
        path: { id: sessionID },
      });
      const messages = messagesResp?.data ?? [];

      const lifecycle = event.type === "session.compacted" ? "compact" : "end";

      sendToHook(
        JSON.stringify({
          event_type: "session",
          lifecycle,
          session,
          messages,
          directory,
        }),
      );
    } catch {
      // Ignore errors so telemetry never disrupts the user's session.
    }
  },

  // Reports the state a tool is about to change, so delivery has to finish
  // before the tool runs.
  "tool.execute.before": async (input, output) => {
    if (!isReportedTool(input?.tool)) return;
    const sessionID = input?.sessionID;
    const data = await getSessionData(client, sessionID);
    await sendToHook(
      JSON.stringify({
        event_type: "tool",
        phase: "pre",
        tool: input?.tool,
        session_id: sessionID,
        call_id: input?.callID,
        tool_version: data.version,
        model: data.model,
        args: output?.args,
        directory,
      }),
    );
  },

  // Reports the state a tool has already produced, so nothing waits on it.
  "tool.execute.after": async (input) => {
    if (!isReportedTool(input?.tool)) return;
    const sessionID = input?.sessionID;
    const data = await getSessionData(client, sessionID);
    sendToHook(
      JSON.stringify({
        event_type: "tool",
        phase: "post",
        tool: input?.tool,
        session_id: sessionID,
        call_id: input?.callID,
        tool_version: data.version,
        model: data.model,
        args: input?.args,
        directory,
      }),
    );
  },
});
