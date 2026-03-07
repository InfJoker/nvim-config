return {
    cmd = {
        "clangd",
        "--all-scopes-completion",
        "--suggest-missing-includes",
        "--background-index",
        "--pch-storage=disk",
        "--cross-file-rename",
        "--log=info",
        "--completion-style=detailed",
        "--enable-config", -- clangd 11+ supports reading from .clangd configuration file
        "--clang-tidy",
    }
}
