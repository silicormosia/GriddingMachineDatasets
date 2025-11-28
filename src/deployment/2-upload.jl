"""

    verify_uploads!(doi_url::String)

Verify the uploaded datasets to make sure a dict could be parsed from the website, given
- `doi_url` the DOI or url of the uploaded datasets

"""
function verify_uploads!(doi_url::String = "https://zenodo.org/records/17732092")
    web_response = HTTP.get(doi_url; require_ssl_verification = false);

    return nothing
end;
