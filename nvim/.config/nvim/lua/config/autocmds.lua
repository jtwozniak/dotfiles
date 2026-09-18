-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- local buffer_unload_group = vim.api.nvim_create_augroup("delayed_buffer_unload", { clear = true })
-- local hidden_generation = {}
--
-- -- Release hidden file contents after a grace period while keeping buffer list entries.
-- vim.api.nvim_create_autocmd("BufHidden", {
--   group = buffer_unload_group,
--   callback = function(args)
--     local buf = args.buf
--     hidden_generation[buf] = (hidden_generation[buf] or 0) + 1
--     local generation = hidden_generation[buf]
--
--     vim.defer_fn(function()
--       if
--         hidden_generation[buf] == generation
--         and vim.api.nvim_buf_is_valid(buf)
--         and vim.api.nvim_buf_is_loaded(buf)
--         and #vim.fn.win_findbuf(buf) == 0
--         and not vim.bo[buf].modified
--         and vim.bo[buf].buftype == ""
--         and vim.api.nvim_buf_get_name(buf) ~= ""
--       then
--         pcall(vim.api.nvim_buf_delete, buf, { unload = true })
--       end
--     end, 30000)
--   end,
-- })

-- Function to open file from clipboard
vim.api.nvim_create_user_command("OpenClipboardPath", function()
  local clipboard = vim.fn.getreg("+"):gsub("[\n\r]", "") -- Get clipboard content and remove newlines
  local path = clipboard

  -- If path doesn't exist, try to find it from project root
  if vim.fn.filereadable(path) == 0 then
    -- Try to find the file from the current working directory
    local found = false
    for _, search_path in ipairs(vim.fn.glob(vim.fn.getcwd() .. "/**/" .. vim.fn.fnamemodify(path, ":t"), false, true)) do
      if string.find(search_path, path, 1, true) then
        path = search_path
        found = true
        break
      end
    end

    if not found then
      vim.notify("File not found: " .. clipboard, vim.log.levels.ERROR)
      return
    end
  end

  -- Open the file
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end, {})

-- Map <leader>fp to open file from clipboard
vim.keymap.set(
  "n",
  "<leader>fp",
  ":OpenClipboardPath<CR>",
  { noremap = true, silent = true, desc = "Open file from clipboard" }
)

-- Function to switch to branch from clipboard
vim.api.nvim_create_user_command("SwitchToBranchFromClipboard", function()
  local clipboard = vim.fn.getreg("+"):gsub("[\n\r]", "") -- Get clipboard content and remove newlines

  -- Helper function to search for branch
  local function find_branch(branches)
    for _, branch in ipairs(branches) do
      local clean_branch = branch:gsub("^%s*", ""):gsub("^%*%s*", ""):gsub("^remotes/origin/", "")
      if string.find(string.lower(clean_branch), string.lower(clipboard), 1, true) then
        return clean_branch
      end
    end
    return nil
  end

  -- Helper function to switch and rebase
  local function switch_and_rebase(branch)
    vim.cmd("Git checkout " .. branch)
    vim.notify("Switched to branch: " .. branch .. ". Performing rebase...", vim.log.levels.INFO)

    local pull_result = vim.fn.system("git pull --rebase")
    if vim.v.shell_error == 0 then
      vim.notify("Rebase completed successfully", vim.log.levels.INFO)
      return true
    else
      vim.notify("Rebase failed: " .. pull_result, vim.log.levels.ERROR)
      return false
    end
  end

  -- First try without fetching
  local branches = vim.fn.systemlist("git branch -a")
  local found_branch = find_branch(branches)

  if found_branch then
    switch_and_rebase(found_branch)
    return
  end

  -- If branch not found, try fetching first
  vim.notify("Branch not found locally, fetching from remote...", vim.log.levels.INFO)
  local fetch_result = vim.fn.system("git fetch")
  if vim.v.shell_error ~= 0 then
    vim.notify("Fetch failed: " .. fetch_result, vim.log.levels.ERROR)
    return
  end

  -- Try again after fetch
  branches = vim.fn.systemlist("git branch -a")
  found_branch = find_branch(branches)

  if found_branch then
    switch_and_rebase(found_branch)
  else
    vim.notify("Branch not found even after fetch: " .. clipboard, vim.log.levels.ERROR)
  end
end, {})

-- Map <leader>gp to switch to branch from clipboard and pull rebase
vim.keymap.set(
  "n",
  "<leader>gp",
  ":SwitchToBranchFromClipboard<CR>",
  { noremap = true, silent = true, desc = "Switch to branch and pull rebase" }
)
