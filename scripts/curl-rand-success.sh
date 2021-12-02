curl-rand-success() {
    cd "$PROJECT_DIR/terraform"
    URL=$(terraform output -raw apigateway_url)api/delay
    log URL $URL

    # random integer between 1 and 4
    # https://stackoverflow.com/a/8988902/1503073
    # test : c=1; while [ $c -le 100 ]; do echo $RANDOM % 4 + 1 | bc; ((c++)); done
    VALUE=$(echo $RANDOM % 4 + 1 | bc)000
    log VALUE $VALUE

    curl $URL \
        --header "Content-Type: application/json" \
        --data '{"success":true, "delay":"'${VALUE}'"}' \
        --silent \
        | jq
}

# delay between 1 to 4 seconds (with lambda timeout after 3 seconds)
curl-rand-success