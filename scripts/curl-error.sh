curl-success() {
    cd "$PROJECT_DIR/terraform"
    URL=$(terraform output -raw apigateway_url)api/delay
    log URL $URL

    # random integer between 10 and 29
    # https://stackoverflow.com/a/8988902/1503073
    # test : c=1; while [ $c -le 100 ]; do echo $RANDOM % 20 + 10 | bc; ((c++)); done
    VALUE=$(echo $RANDOM % 20 + 10 | bc)000
    log VALUE $VALUE

    curl $URL \
        --header "Content-Type: application/json" \
        --data '{"success":false, "delay":"'${VALUE}'"}' \
        --silent \
        | jq
}

curl-success