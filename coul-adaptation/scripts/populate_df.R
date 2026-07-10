require(jsonlite)

populate_df = function(json_file) {
    json_obj = read_json(json_file)

    if (length(json_obj$chunked_blocks) == 0)
      return(NULL)

    my_data = list(
        "local_id" = character(0),
        "parent_id" = character(0),
        "text" = character(0),
        "libguide_title" = character(0),
        "libguide_url" = character(0),
        "chunk_title" = character(0),
        "chunk_url" = character(0),
        "external_url" = character(0),
        "authors" = character(0)
        )

    my_df = data.frame("local_id" = unlist(json_obj$indx))
    #my_df$text = json_obj$chunked_blocks |> unlist() |> paste(collapse = ' ') # maybe change if the chunks are sometimes nested?
    my_df$text = json_obj$blocks |> unlist()
    my_df$parent_id = basename(json_file)
    my_df$libguide_title = basename(json_obj$filepath)
    my_df$libguide_url = json_obj$filepath
    my_df$chunk_title = paste(basename(json_obj$filepath), json_obj$indx, sep = "_")
    my_df$chunk_url = basename(json_obj$filepath)
    my_df$external_url = json_obj$filepath
    my_df$authors = ""

    my_df
}
