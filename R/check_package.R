
check_package <- function(pkg){
    if (missing(pkg)){
        (pkg <- .libPaths() |> list.files(full.names = TRUE))
        (pkg <- pkg[do::Replace0(pkg,'.*/')=='gR'])
    }
    pkg <- c(do::desc2df(pkg)$Depends,do::desc2df(pkg)$Imports) |> paste0(collapse = ',')
    pkg <- do::Replace0(pkg,' ') |> strsplit(',') |> do::list1() |> do::Replace0('\\(.*') |> do::rm_nchar(1)
    installed <- .libPaths() |> lapply(list.files) |> unlist()
    pkg <- pkg[!pkg %in% installed]
    if (length(pkg)>0){
        for (i in pkg) {
            installed <- .libPaths() |> lapply(list.files) |> unlist()
            if (i %in% installed) next(i)
            eval(parse(text=sprintf("install.packages('%s')",i)))
        }
    }
}
