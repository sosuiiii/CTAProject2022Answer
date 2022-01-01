$PODS_ROOT/SwiftGen/bin/swiftgen config run
if which “${PODS_ROOT}/SwiftLint/swiftlint” >/dev/null; then
${PODS_ROOT}/SwiftLint/swiftlint
swiftlint autocorrect --format
else
echo “warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint”
fi
