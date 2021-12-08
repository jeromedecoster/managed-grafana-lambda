setup() {
    cd "$PROJECT_DIR/terraform"
    terraform init

    cd "$PROJECT_DIR"
    info compute project size
    # project crazy size ! 
    # 247M    .
    du --summarize --human-readable

    info compute files count
    # 70
    find . -type f | wc -l
}

setup
