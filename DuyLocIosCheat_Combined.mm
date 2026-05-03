<button class=\"tab-button\" onclick=\"openTab('settings', this)\">Settings</button> \
        </div> \
        <div class=\"content-area\"> \
            <div id=\"aimbot\" class=\"tab-content\"> \
                <div class=\"option-category\">AIMBOT FEATURES</div> \
                <span class=\"description\">Automatically lock on enemies.</span> \
                <div class=\"option-row\"> \
                    <span>Aimlock + Headshot</span> \
                    <label class=\"switch\"><input type=\"checkbox\" onchange=\"sendAction('aimbot', this.checked)\"><span class=\"slider\"></span></label> \
                </div> \
                <div class=\"option-row\"> \
                    <span>Show FOV Circle</span> \
                    <label class=\"switch\"><input type=\"checkbox\" id=\"fov-toggle\" checked onchange=\"toggleFovDisplay()\"><span class=\"slider\"></span></label> \
                </div> \
            </div> \
            <div id=\"visuals\" class=\"tab-content\" style=\"display:none;\"> \
                <div class=\"option-category\">VISUALS</div> \
                <div class=\"option-row\"> \
                    <span>ESP Wallhack</span> \
                    <label class=\"switch\"><input type=\"checkbox\" onchange=\"sendAction('esp', this.checked)\"><span class=\"slider\"></span></label> \
                </div> \
            </div> \
            <div id=\"misc\" class=\"tab-content\" style=\"display:none;\"> \
                <div class=\"option-category\">MISC</div> \
                <div class=\"option-row\"> \
                    <span>No Recoil</span> \
                    <label class=\"switch\"><input type=\"checkbox\" onchange=\"sendAction('recoil', this.checked)\"><span class=\"slider\"></span></label> \
                </div> \
                <div class=\"option-row\"> \
                    <span>Antiban Bypass</span> \
                    <label class=\"switch\"><input type=\"checkbox\" onchange=\"sendAction('antiban', this.checked)\"><span class=\"slider\"></span></label> \
                </div> \
            </div> \
            <div id=\"settings\" class=\"tab-content\" style=\"display:none;\"> \
                <div class=\"option-category\">SETTINGS</div> \
                <div class=\"option-row\"> \
                    <span>FOV Size</span> \
                    <div style=\"width:100px;\"> \
                        <input type=\"range\" id=\"fov-range\" min=\"30\" max=\"500\" value=\"150\" oninput=\"updateRangeValue(this); updateFovSize(this.value)\"> \
                        <span class=\"range-value\">150.0°</span> \
                    </div> \
                </div> \
            </div> \
        </div> \
    </div> \
</div> \
<script> \
    function sendAction(feature, status) { \
        window.location.href = 'duyloccheat://' + feature + '/' + status; \
    } \
    const menuPanel = document.getElementById('menu-panel'); \
    const fovCircle = document.getElementById('fov-circle'); \
    function updateFovSize(val) { fovCircle.style.width = val + 'px'; fovCircle.style.height = val + 'px'; } \
    function toggleFovDisplay() { const isChecked = document.getElementById('fov-toggle').checked; fovCircle.style.display = isChecked ? 'block' : 'none'; } \
    function toggleMenu() { menuPanel.style.display = (menuPanel.style.display === 'none') ? 'block' : 'none'; } \
    function openTab(tabId, button) { \
        const contents = document.getElementsByClassName('tab-content'); \
        for (let i = 0; i < contents.length; i++) contents[i].style.display = 'none'; \
        const buttons = document.getElementsByClassName('tab-button'); \
        for (let i = 0; i < buttons.length; i++) buttons[i].classList.remove('active'); \
        document.getElementById(tabId).style.display = 'block'; button.classList.add('active'); \
    } \
    function updateRangeValue(slider) { slider.nextElementSibling.innerText = slider.value + (slider.id === 'fov-range' ? '.0°' : '%'); } \
    let isDragging = false, startX, startY, initialLeft, initialTop; \
    menuPanel.