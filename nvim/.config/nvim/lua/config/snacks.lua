local M = {}

function M.copy_relative_path(picker)
  local item = picker:current()
  local path = item and item.file
  if not path then
    return
  end

  local relative_path = vim.fn.fnamemodify(path, ":.")
  vim.fn.setreg("+", relative_path)
  vim.notify("Copied: " .. relative_path)
end

function M.git_log_dir(picker, item)
  if not item or not item.dir then
    return
  end
  Snacks.picker.git_log({
    cmd_args = { "--", item.file },
  })
end

local function dirty_files()
  local cwd = vim.uv.cwd() or "."
  local root = Snacks.git.get_root(cwd)
  if not root then
    Snacks.notify.warn("Not a git repository")
    return
  end

  local result = vim.system({
    "git",
    "-c",
    "core.quotepath=false",
    "status",
    "-uall",
    "--porcelain=v1",
    "-z",
  }, {
    cwd = root,
    text = true,
    timeout = 5000,
  }):wait()
  if result.code ~= 0 then
    Snacks.notify.warn("Could not get git status")
    return
  end

  local files = {}
  local parts = vim.split(result.stdout or "", "\0", { plain = true, trimempty = true })
  local i = 1
  while i <= #parts do
    local status, file = parts[i]:match("^(..) (.+)$")
    if status then
      local path = file
      if status:find("[RC]") then
        i = i + 1
        path = parts[i] or file
      end
      local abs = svim.fs.normalize(root .. "/" .. path)
      if vim.uv.fs_stat(abs) then
        files[#files + 1] = abs
      end
    end
    i = i + 1
  end
  return files
end

function M.grep_dirty()
  local files = dirty_files()
  if not files then
    return
  end
  if #files == 0 then
    Snacks.notify.warn("No dirty files")
    return
  end
  Snacks.picker.grep({ dirs = files })
end

local function in_cwd(path, cwd)
  return path == cwd or path:sub(1, #cwd + 1) == cwd .. "/"
end

local function develop_set(picker)
  local cwd = picker:cwd()
  local root = Snacks.git.get_root(cwd)
  if not root then
    Snacks.notify.warn("Not a git repository")
    return
  end

  local result = vim.system({ "git", "diff", "--name-only", "--merge-base", "develop" }, {
    cwd = root,
    text = true,
    timeout = 5000,
  }):wait()
  if result.code ~= 0 then
    Snacks.notify.warn("Could not diff against develop")
    return
  end

  local files, dirs = {}, {}
  for line in vim.gsplit(result.stdout or "", "\n", { trimempty = true }) do
    local path = svim.fs.normalize(root .. "/" .. line)
    if in_cwd(path, cwd) then
      files[path] = true
      for dir in Snacks.picker.util.parents(path, cwd) do
        dirs[dir] = true
      end
    end
  end
  return { files = files, dirs = dirs }
end

function M.explorer_git_transform(item, ctx)
  local picker = ctx and ctx.picker
  if not picker then
    return item
  end

  local mode = picker.opts.git_filter
  if not mode then
    return item
  end

  local cwd = picker:cwd()
  if item.file == cwd then
    return item
  end

  if mode == "dirty" then
    local node = require("snacks.explorer.tree"):node(item.file)
    if not node or node.ignored then
      return false
    end
    local status = node.status or node.dir_status
    if status and status:sub(1, 1) ~= "!" then
      return item
    end
    return false
  end

  if mode == "develop" then
    local set = picker.opts.git_filter_set
    if not set then
      return item
    end
    if set.files[item.file] or set.dirs[item.file] then
      return item
    end
    return false
  end

  return item
end

function M.explorer_toggle_git_filter(picker, mode)
  if picker.opts.git_filter == mode then
    picker.opts.git_filter = nil
    picker.opts.git_filter_set = nil
    require("snacks.explorer.actions").update(picker, { refresh = true })
    return
  end

  local Tree = require("snacks.explorer.tree")
  if mode == "develop" then
    local set = develop_set(picker)
    if not set then
      return
    end
    picker.opts.git_filter_set = set
    for path in pairs(set.files) do
      Tree:open(path)
    end
  else
    picker.opts.git_filter_set = nil
    local cwd = picker:cwd()
    Tree:walk(Tree:find(cwd), function(node)
      if node.path == cwd then
        return
      end
      local status = node.status or node.dir_status
      if not status or node.ignored or status:sub(1, 1) == "!" then
        return
      end
      Tree:open(node.path)
    end, { all = true })
  end

  picker.opts.git_filter = mode
  require("snacks.explorer.actions").update(picker, { refresh = true })
end

function M.explorer_toggle_dirty(picker)
  M.explorer_toggle_git_filter(picker, "dirty")
end

function M.explorer_toggle_develop(picker)
  M.explorer_toggle_git_filter(picker, "develop")
end

return M
