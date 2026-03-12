local M = {
  "InfJoker/nvim-shader-art",
  commit = "15dce12",
  dependencies = { "goolord/alpha-nvim" },
  event = "VimEnter",
  build = "cd shader-art-render && cargo build --release",
}

function M.config()
  local ok, shader_art = pcall(require, "shader-art")
  if not ok then
    return
  end
  shader_art.setup { shader = nil, mode = "auto", fps = 15 }
end

return M
