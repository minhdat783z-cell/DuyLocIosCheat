ARCHS = arm64 arm64e
TARGET = iphone:clang:14.5:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DuyLocIosCheat
DuyLocIosCheat_FILES = DuyLocIosCheat_Combined.mm
# THÊM WebKit VÀO ĐÂY
DuyLocIosCheat_FRAMEWORKS = UIKit Foundation WebKit

include $(THEOS)/makefiles/tweak.mk
