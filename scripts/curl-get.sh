curl-get() {
    cd "$PROJECT_DIR/terraform"
    URL=$(terraform output -raw apigateway_url)
    log URL $URL

    curl $URL \
        --silent \
        | jq
}

curl-get