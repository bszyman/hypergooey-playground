//
//  AppDelegate.m
//  HyperGooey Playground
//
//  Created by Ben Szymanski on 3/5/26.
//

#import "AppDelegate.h"
#import <HyperGooey/HyperGooey.h>

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@property (strong) HyperGooeyViewController *gooeyViewController;

@property (weak) IBOutlet NSWindow *openInterfaceWindow;
@property (weak) IBOutlet NSTextField *interfaceUrlTextField;

@property (copy) NSString *currentIntefaceUrl;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Urls to try:
    // * SourceList - https://workspaces.fastgooey.com/hypermedia/fymxP-Ad8UqAx6OpuEIL7w
    // * Outline - https://workspaces.fastgooey.com/hypermedia/5yha7HvKYU-85x_kbq0KRQ
    // * Collection -
    //   * https://workspaces.fastgooey.com/hypermedia/KOX7EPdq0ky5Qkp5wPg42A
    //   * https://workspaces.fastgooey.com/hypermedia/4RY89bglr0i78hSVJv94TQ
    //   * https://workspaces.fastgooey.com/hypermedia/lkqRmQ0wdU-67bEAZemWSg
    //   * https://workspaces.fastgooey.com/hypermedia/FKZJTULLkUe2uWAtO3GbZg
    //   * https://workspaces.fastgooey.com/hypermedia/aVq9ANgK40u0qVpIyXq_lA
    // * Table - https://workspaces.fastgooey.com/hypermedia/T5HkX9CaG0KwXS_7vidBlA
    // * Content - https://workspaces.fastgooey.com/hypermedia/35ynSn4JZk2VjZm_rYVJBA
    
    self.currentIntefaceUrl = [NSMutableString stringWithString:@"https://demo.hyperfastinteractive.com/"];
    
    self.gooeyViewController = [[HyperGooeyViewController alloc] initWithUrl:self.currentIntefaceUrl];
    [self.gooeyViewController mountInContainer:self.window.contentView
                                        parent:self.window.contentViewController];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

-(IBAction)cancelOpenInterface:(id)sender
{
    [self.window endSheet:self.openInterfaceWindow
               returnCode:NSModalResponseCancel];
}

- (IBAction)navigateToInterface:(id)sender
{
    if (self.openInterfaceWindow.sheetParent != nil) {
        [self.window endSheet:self.openInterfaceWindow
                   returnCode:NSModalResponseOK];
        return;
    }

    [self refreshInterface:nil];
}

- (IBAction)presentOpenInterfaceSheet:(id)sender
{
    self.interfaceUrlTextField.stringValue = self.currentIntefaceUrl ?: @"";

    [self.window beginSheet:self.openInterfaceWindow
          completionHandler:^(NSModalResponse response) {
        if (response != NSModalResponseOK) {
            return;
        }

        self.currentIntefaceUrl = self.interfaceUrlTextField.stringValue;
        [self refreshInterface:nil];
    }];
}

- (IBAction)refreshInterface:(id)sender
{
    NSViewController *containerViewController = self.window.contentViewController;
    for (NSViewController *childViewController in [containerViewController.childViewControllers copy]) {
        [childViewController removeFromParentViewController];
    }

    for (NSView *subview in [self.window.contentView.subviews copy]) {
        [subview removeFromSuperview];
    }

    self.gooeyViewController = [[HyperGooeyViewController alloc] initWithUrl:self.currentIntefaceUrl];
    [self.gooeyViewController mountInContainer:self.window.contentView
                                        parent:self.window.contentViewController];
}


@end
