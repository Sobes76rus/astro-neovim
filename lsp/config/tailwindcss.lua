return function(opts)
  opts.settings = {
    tailwindCSS = {
      experimental = {
        configFile = ".nuxt/tailwind.config.d.ts",
        classRegex = { "class=`([^`]*)`" },
      },
      emmetCompletions = true,
      suggestions = true,
      validate = true,
    },
  }
  opts.init_options = {
    userLanguages = { pug = "html" },
  }
  opts.filetypes = { "html", "pug", "vue" }

  return opts
end
