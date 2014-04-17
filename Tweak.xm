#import <UIKit/UIKit.h>

UILabel *label = nil;
int newPassValue = nil;
NSString *newPass = nil;
BOOL unlockOnce = FALSE;
BOOL shouldUnlock = FALSE;
int i = 0;

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {

	%orig;
	unlockOnce = TRUE;

}

%end

%hook SBDeviceLockController

- (BOOL)attemptDeviceUnlockWithPassword:(NSString *)passcode appRequested:(BOOL)requested {

	BOOL origValue = %orig;

	if (!origValue) {
		i = 0;
		return FALSE;
	}

	else if (origValue) {
		if (i == 0) {
			i++;
			return NO;
		}
		if (i == 1) {
			shouldUnlock = YES;
		}

		if (shouldUnlock) {
			return YES;
		}

	}

	return %orig;

}

%end

%hook SBUIPasscodeLockViewWithKeypad

- (id)statusTitleView {

    label = MSHookIvar<UILabel *>(self, "_statusTitleView");

	if (unlockOnce) {
		label.text = [NSString stringWithFormat:@"For security reasons, unlock once after respring."];
		return label;
	}

	return %orig;

}

%end

%hook SBLockScreenViewController

- (void)prepareForUIUnlock {

	unlockOnce = FALSE;
	i = 0;

	%orig;

}

%end

%hook SBLockScreenView

-(void)setCustomSlideToUnlockText:(id)arg1 {

	i = 0;
	%orig;
	
}

%end

