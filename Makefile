include theos/makefiles/common.mk

TWEAK_NAME = Sirious
Sirious_FILES = Tweak.xm UIDevice-Hardware.m
Sirious_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
