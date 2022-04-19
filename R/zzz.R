

#Check whether on install is sufficient

.onLoad <- function(libname, pkgname) {
  if (Sys.info()[1] == "Linux") {
    dir.create('~/.fonts')
    file.copy("inst/extdata/fonts/Verdana.ttf", "~/.fonts")
    system('fc-cache -f ~/.fonts')
  }
  if (Sys.info()[1] == "Windows") {
    windowsFonts()
    extrafont::font_import(pattern = "Verdana", prompt = FALSE)
    extrafont::loadfonts(device = "win")
    windowsFonts()
  }
  print(extrafont::fonts())
}


