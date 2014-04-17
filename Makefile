ARCHS = armv7 armv7s arm64
GO_EASY_ON_ME=1
include theos/makefiles/common.mk

TWEAK_NAME = DoublePass
DoublePass_FILES = Tweak.xm
DoublePass_FRAMEWORKS = UIKit
DoublePass_CFLAGS = -fobjc-arc


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
