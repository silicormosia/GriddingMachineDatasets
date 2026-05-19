"""

    verify_uploads!(doi_url::String)

Verify the uploaded datasets to make sure a dict could be parsed from the website, given
- `doi_url` the DOI or url of the uploaded datasets

"""
function update_yaml_library! end;

update_yaml_library!(doi_url::String = "https://zenodo.org/records/17873650") = (
    web_response = HTTP.get(doi_url; require_ssl_verification = false);

    # if the response is not 200, raise an error
    if web_response.status != 200
        error("Failed to access the uploaded datasets at $(doi_url)!");
    end;

    #=
    item key

    - if key exists
      - if url exists in the urls -> nothing
      - otherwise, append the url to the urls
    - if key does not exist
      - create a new item with the key and url
      - add ftp url
      - upload the data to ftp

    new_item = Dict{String,Any}(
        "PATH" => "public/v0",
        "URL"  => ["url", "ftp://"],
    );

    =#

    return web_response
);
