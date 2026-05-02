ARCHS = arm64 arm64e
TARGET = iphone:clang:14.5:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DuyLocIosCheat
DuyLocIosCheat_FILES = DuyLocIosCheat_Combined.mm
DuyLocIosCheat_FRAMEWORKS = UIKit Foundation

     include $(THEOS)/makefiles/library.mk
