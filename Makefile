PRODUCT_NAME := CTAProject
WORKSPACE_NAME := ${PRODUCT_NAME}.xcworkspace


xcodegen: 
	@mint run yonaskolb/XcodeGen xcodegen generate
bootstrap:
	mint bootstrap
setup:
	mint bootstrap
	make xcodegen
	pod install
	open ./${WORKSPACE_NAME}
setup-b:
	mint bootstrap
	make xcodegen
	bundle exec pod install
	open ./${WORKSPACE_NAME}
open:
	open ./${WORKSPACE_NAME}
