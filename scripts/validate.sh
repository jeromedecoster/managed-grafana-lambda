validate() {
    cd "$PROJECT_DIR/terraform"
    terraform fmt -recursive
    terraform validate
}

validate
