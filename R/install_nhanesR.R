#' install
#'
#' @param token token
#'
#' @return install
#' @export
#'
install_gR <- function(token){
    e <- tryCatch(detach("package:gR", unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    do::formal_dir(dest)
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/gR.zip'))

    if (do::is.windows()){
        download.file(url = 'https://codeload.github.com/zhishi-gR/gR_win/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }else{
        download.file(url = 'https://codeload.github.com/zhishi-gR/gR_mac/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }

    if (do::is.windows()){
        main <- paste0(dest,'/gR_win-main')
        (gR <- list.files(main,'gR_',full.names = TRUE))
        (gR <- gR[do::right(gR,3)=='zip'])
        (k <- do::Replace0(gR,'.*gR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max())
        unzip(gR[k],files = 'gR/DESCRIPTION',exdir = main)
    }else{
        main <- paste0(dest,'/gR_mac-main')
        gR <- list.files(main,'gR_',full.names = TRUE)
        gR <- gR[do::right(gR,3)=='tgz']
        k <- do::Replace0(gR,'.*gR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        untar(gR[k],files = 'gR/DESCRIPTION',exdir = main)
    }

    (desc <- paste0(main,'/gR'))
    check_package(desc)

    install.packages(pkgs = gR[k],repos = NULL,quiet = FALSE)
    message('Done(gR)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}


