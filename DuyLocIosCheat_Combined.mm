#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// --- PHẦN 1: HTML CODE (GIỮ NGUYÊN NHƯNG SỬA HÀM SEND ACTION) ---
static NSString *htmlCode = @"<!DOCTYPE html> \
<html lang=\"vi\"> \
<head> \
    <meta charset=\"UTF-8\"> \
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\"> \
    <title>DuyLocIosCheat</title> \
    <style> \
        body { margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: transparent; color: #ddd; user-select: none; overflow: hidden; } \
        #fov-circle { position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); border: 1.5px solid #a855f7; border-radius: 50%; pointer-events: none; z-index: 1; display: block; box-shadow: 0 0 8px rgba(168, 85, 247, 0.4); width: 150px; height: 150px; } \
        #menu-panel { width: 380px; height: 320px; background: rgba(18, 18, 18, 0.95); border: 1px solid #a855f7; border-radius: 8px; position: fixed; top: 15%; left: 10px; display: block; z-index: 9999; overflow: hidden; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.7); } \
        .panel-header { padding: 10px; border-bottom: 1px solid #333; display: flex; justify-content: space-between; align-items: center; } \
        .panel-title { color: #a855f7; font-weight: bold; font-size: 1.1rem; } \
        .close-btn { background: none; border: none; color: #ddd; font-size: 1.2rem; cursor: pointer; } \
        .menu-content { display: flex; height: calc(100% - 41px); } \
        .sidebar { width: 80px; background-color: rgba(10, 10, 10, 0.95); border-right: 1px solid #333; padding-top: 5px; } \
        .tab-button { width: 100%; padding: 15px 0; background: none; border: none; color: #bbb; text-align: center; cursor: pointer; } \
        .tab-button.active { color: #fff; border-left: 2px solid #a855f7; background: rgba(168, 85, 247, 0.1); } \
        .content-area { flex-grow: 1; padding: 15px; overflow-y: auto; } \
        .option-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; } \
        .switch { position: relative; display: inline-block; width: 36px; height: 18px; } \
        .switch input { display: none; } \
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #444; border-radius: 20px; } \
        input:checked + .slider { background-color: #a855f7; } \
        .slider:before { position: absolute; content: ''; height: 14px; width: 14px; left: 2px; bottom: 2px; background-color: white; border-radius: 50%; transition: .4s; } \
        input:checked + .slider:before { transform: translateX(18px); } \
    </style> \
</head> \
<body> \
<div id=\"fov-circle\"></div> \
<div id=\"menu-panel\"> \
    <div class=\"panel-header\"> \
        <div class=\"panel-title\">DuyLocIosCheat</div> \
        <button class=\"close-btn\" onclick=\"toggleMenu()\">×</button> \
    </div> \
    <div class=\"menu-content\"> \
        <div class=\"sidebar\"> \
            <button class=\"tab-button active\" onclick=\"openTab('aimbot', this)\">Aim</button> \
            <button class=\"tab-button\" onclick=\"openTab('misc', this)\">Misc</button> \
        </div> \
        <div class=\"content-area\"> \
            <div id=\"aimbot\" class=\"tab-content\"> \
                <div class=\"option-row\"> \
                    <span>Aimlock + Headshot</span> \
                    <label class=\"switch\"><input type=\"checkbox\" onchange=\"sendAction('aimbot', this.checked)\"><span class=\"slider\"></span></label> \
                </div> \
            </div> \
            <div id=\"misc\" class=\"tab-content\" style=\"display:none;\"> \
                <div class=\"option-row\"> \
                    <span>No Recoil</span> \
                    <label class=\"switch\"><input type=\"checkbox\" onchange=\"sendAction('recoil', this.checked)\"><span class=\"slider\"></span></label> \
                </div> \
            </div> \
        </div> \
    </div> \
</div> \
<script> \
    function sendAction(feature, status) { \
        window.webkit.messageHandlers.duyloc.postMessage({f: feature, s: status}); \
    } \
    function openTab(tabId, btn) { \
        var i, content, tabs; \
        content = document.getElementsByClassName('tab-content'); \
        for (i = 0; i < content.length; i++) content[i].style.display = 'none'; \
        tabs = document.getElementsByClassName('tab-button'); \
        for (i = 0; i < tabs.length; i++) tabs[i].classList.remove('active'); \
        document.getElementById(tabId).style.display = 'block'; \
        btn.classList.add('active'); \
    } \
    function toggleMenu() { \
        var p = document.getElementById('menu-panel'); \
        p.style.display = (p.style.display === 'none') ? 'block' : 'none'; \
    } \
    /* Logic kéo thả menu */ \
    var menu = document.getElementById('menu-panel'); \
    var isDragging = false, x, y, l, t; \
    menu.addEventListener('touchstart', function(e) { \
        if(e.target.tagName === 'INPUT' || e.target.tagName === 'BUTTON') return; \
        isDragging = true; x = e.touches[0].clientX; y = e.touches[0].clientY; \
        l = menu.offsetLeft; t = menu.offsetTop; \
    }); \
    document.addEventListener('touchmove', function(e) { \
        if(!isDragging) return; \
        var dx = e.touches[0].clientX - x; var dy = e.touches[0].clientY - y; \
        menu.style.left = (l + dx) + 'px'; menu.style.top = (t + dy) + 'px'; \
    }); \
    document.addEventListener('touchend', function() { isDragging = false; }); \
</script> \
</body> \
</html>";

// --- PHẦN 2: LOGIC HỆ THỐNG (THẬT) ---

uintptr_t get_Real_Offset(uintptr_t offset) {
    return _dyld_get_image_header(0) + offset;
}

void patch_memory(uintptr_t address, const char *hex) {
    if (!address) return;
    
    // Chuyển Hex string sang bytes
    size_t len = strlen(hex) / 2;
    unsigned char *data = malloc(len);
    for (size_t i = 0; i < len; i++) {
        sscanf(hex + 2 * i, "%02hhx", &data[i]);
    }

    // Mở khóa quyền ghi vào bộ nhớ
    vm_protect(mach_task_self(), (vm_address_t)address, len, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    memcpy((void *)address, data, len);
    vm_protect(mach_task_self(), (vm_address_t)address, len, false, VM_PROT_READ | VM_PROT_EXECUTE);
    
    free(data);
}

// --- PHẦN 3: HIỂN THỊ MENU VỚI WKWEBVIEW ---

@interface DuyLocLoader : UIWindow <WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webMenu;
@end

@implementation DuyLocLoader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Thiết lập Window để luôn nổi lên trên cùng
        self.windowLevel = UIWindowLevelStatusBar + 100.0;
        self.backgroundColor = [UIColor clearColor];
        [self setHidden:NO];
        
        // Tránh việc bị hệ thống tự động ẩn
        if (@available(iOS 13.0, *)) {
            self.windowScene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] anyObject];
        }

        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addScriptMessageHandler:self name:@"duyloc"];

        self.webMenu = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
        self.webMenu.backgroundColor = [UIColor clearColor];
        self.webMenu.scrollView.backgroundColor = [UIColor clearColor];
        self.webMenu.opaque = NO;
        self.webMenu.scrollView.scrollEnabled = NO;
        
        [self.webMenu loadHTMLString:htmlCode baseURL:nil];
        [self addSubview:self.webMenu];
    }
    return self;
}

// Nhận dữ liệu từ JavaScript
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"duyloc"]) {
        NSDictionary *data = message.body;
        NSString *feature = data[@"f"];
        BOOL status = [data[@"s"] boolValue];

        if ([feature isEqualToString:@"aimbot"] && status) {
            patch_memory(get_Real_Offset(0x2B4D5E8), "200080D2C0035FD6");
            patch_memory(get_Real_Offset(0x3C5E6F4), "200080D2C0035FD6");
        } else if ([feature isEqualToString:@"recoil"] && status) {
            patch_memory(get_Real_Offset(0x5E7A924), "000080D2C0035FD6");
        }
    }
}

// Sửa lại hitTest để có thể bấm được vào Menu Panel
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    // Nếu chạm vào vùng không phải Menu, cho phép chạm xuyên qua game
    if (hitView == self.webMenu || hitView == self) {
        return nil;
    }
    return hitView;
}
@end
