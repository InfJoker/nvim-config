local M = {
  "InfJoker/nvim-shader-art",
  commit = "2f5b324ef3a02499536d301e9e72bcdf664e832d",
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
