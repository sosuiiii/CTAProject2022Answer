PRODUCT_NAME := CTAProject
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace

setup:
	xcodegen generate
	pod install
	open ./${WORKSPACE_NAME}
pod-install:
	pod install
pod-update:
	pod update
setup-b:
	xcodegen generate
	bundle exec pod install
	open ./${WORKSPACE_NAME}
pod-install-b:
	bundle exec pod install
pod-update-b:
	bundle exec pod update
open:
	open ./${WORKSPACE_NAME}
