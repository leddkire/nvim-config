-- TODO:
--   - Mapping to select active bookmark group
--   - Mapping to select files within bookmark group (up to 4, like in harpoon)
--   - Mapping to invoke :BookmarksQFList <active tab group>
--   - Mapping to clear current active bookmark group
--     - If it's not the only group with bookmarks, activate the next one
--   - Create plugin that integrates with telescope
--     - Add file under cursor to active bookmark group
--     - Add file under cursor to specific bookmark group
--     - Add file under cursor to new bookmark group and activate it
--     - Show which bookmark group the file belongs to
--     - Remove the file from the assigned bookmark
--   - Create plugin that integrates with oil
--     - Add file under cursor to active bookmark group
--     - Add file under cursor to specific bookmark group
--     - Add file under cursor to new bookmark group and activate it
--     - Show which bookmark group the file belongs to
--     - Remove the file from the assigned bookmark
require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- disables mark tracking for specific buftypes. default {}
  excluded_buftypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    -- defaults to false.
    annotate = false,
  },
  mappings = {}
}
