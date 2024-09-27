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

    # 检查是否安装了gR，把data拷贝过来
    gf <- paste0(.libPaths(),'/gR')
    gf <- gf[file.exists(gf)]
    copydata <- F
    if (length(gf)>0){
        (gf <- gf[1])
        (gfs <- paste0(gf,'/data'))
        if (file.exists(gfs) & length(list.files(gfs))>0){
            (todata <- paste0(do::file.dir(gR[k]),'/data'))
            copy_with_structure(gfs,todata)
            copydata <- T
        }
    }

    install.packages(pkgs = gR[k],repos = NULL,quiet = FALSE)
    if (copydata){
        if (!dir.exists(gfs)) dir.create(gfs,showWarnings = F,recursive = T)
        copy_with_structure(todata,gfs)
    }


    message('Done(gR)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}
copy_with_structure <- function(src_dir, dest_dir) {
    # 获取所有的文件路径
    files <- list.files(src_dir, recursive = TRUE, full.names = TRUE)

    # 遍历每个文件
    for (file in files) {
        # 获取相对于源目录的相对路径

        (relative_path <- do::Trim_left(do::knife_left(file,nchar(src_dir)),'/'))

        # 目标文件的完整路径
        target_file <- file.path(dest_dir, relative_path)

        # 获取目标文件夹路径
        target_dir <- dirname(target_file)

        # 如果目标文件夹不存在，创建它
        if (!dir.exists(target_dir)) {
            dir.create(target_dir, recursive = TRUE)
        }

        # 复制文件到目标路径
        file.copy(file, target_file,overwrite = T)
    }
}
# # 使用示例
# src_dir <- "path/to/source/directory"
# dest_dir <- "path/to/destination/directory"
# copy_with_structure(src_dir, dest_dir)

