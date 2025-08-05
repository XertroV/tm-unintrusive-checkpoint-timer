[Setting category="Custom Pos" name="Enable Plugin" description="When false, it won't do anything."]
bool ShowWindow = true;

[Setting category="Custom Pos" name="Enable Custom Position"]
bool S_EnableCustomPos = false;

[Setting category="Custom Pos" name="Show Custom Position Locator" description="You can drag it around while in a map. To hide the CP indicator when locator is off, use the X in the window corner. (Will stay visible till next CP if you disable locator from here.)"]
bool g_DrawLocator = false;

[Setting category="Custom Pos" name="Position (ML Coords)" description="Default: -10, 45; Unintrusive Default: -10, 66.5."]
vec2 S_CustomPos = vec2(-10, 66.5);

#if DEV
[SettingsTab name="DEV" order=999]
void RenderDevSetingsTab() {
    auto net = cast<CTrackManiaNetwork>(GetApp().Network);
    if (net.ClientManiaAppPlayground !is null && CheckpointsFrame !is null) {
        if (UI::Button("Explore CP Frame")) { ExploreNod("CP Frame", CheckpointsFrame); }
        if (UI::Button("Explore CP Frame Parent 1")) { ExploreNod("CP Frame Parent 1", CheckpointsFrame.Parent); }
        if (UI::Button("Explore CP Frame Parent 2")) { ExploreNod("CP Frame Parent 2", CheckpointsFrame.Parent.Parent); }
    }
    UI::Text("xExtra: " + xExtra);
    UI::Text("screen: " + screen.ToString());
    UI::Text("idealScreen: " + idealScreen.ToString());
    auto midpoint = GetScreen() / 2.;
    UI::Text("screen midpoint: " + (midpoint).ToString());
    UI::Text("ML midpoint: " + ScreenToML(midpoint).ToString());
    UI::Text("s1 * midpoint: " + (s1 * midpoint).xy.ToString());
    UI::Text("s2 * midpoint: " + (s2 * midpoint).xy.ToString());
    UI::Text("s3 * midpoint: " + (s3 * midpoint).xy.ToString());
    UI::Text("s4 * midpoint: " + (s4 * midpoint).xy.ToString());
}
#endif

bool wasActive = false;

void DrawLocator() {
    if (!g_DrawLocator) return;
    vec2 mlPosOffset = vec2(10, 0);
    auto winPos = MLToScreen(S_CustomPos - mlPosOffset) / UI::GetScale();
    UI::PushStyleColor(UI::Col::WindowBg, vec4(0, 0, 0, .4));
    UI::SetNextWindowPos(winPos.x, winPos.y, wasActive ? UI::Cond::Appearing : UI::Cond::Always);
    auto winSize = vec2(250, 150) * Draw::GetHeight() / 1440.;
    UI::SetNextWindowSize(winSize.x, winSize.y, UI::Cond::Always);
    if (UI::Begin("cp locator", g_DrawLocator, UI::WindowFlags::NoCollapse | UI::WindowFlags::NoResize)) {
        wasActive = UI::IsWindowFocused();
        if (wasActive) {
            auto newWinPos = UI::GetWindowPos();
            S_CustomPos = ScreenToML(newWinPos) + mlPosOffset;
        }
    }
    UI::End();
    UI::PopStyleColor();

    if (GetApp().Network.ClientManiaAppPlayground !is null && CheckpointsFrame !is null) {
        // CheckpointsFrame.Visible = true;
        CheckpointsFrame.Controls[0].Visible = g_DrawLocator;
    }
}

mat3 screenToML;
mat3 mlToScreen;
float xExtra;
mat3 s1, s2, s3, s4;
vec2 screen, idealScreen;
const vec2 MLBounds = vec2(160, 90);

void RenderEarly() {
    screen = GetScreen();
    xExtra = Math::Max(0.0, screen.x - (screen.y * 16. / 9.)) / 2.;
    auto xOff = vec2(-1.0 * xExtra, 0);
    idealScreen = screen + xOff * 2.;
    s1 = mat3::Translate(xOff);
    s2 = mat3::Inverse(mat3::Scale(idealScreen)) * s1;
    s3 = mat3::Translate(vec2(-.5)) * s2;
    s4 = mat3::Scale(MLBounds * vec2(2., -2.)) * s3;
    screenToML = s4; // mat3::Translate(xOff) * mat3::Scale(vec2(1.0) / screen) * mat3::Translate(vec2(-.5)) * mat3::Scale(MLBounds * vec2(2., -2.));
    mlToScreen = mat3::Inverse(screenToML);
}

vec2 GetScreen() {
    return vec2(Draw::GetWidth(), Draw::GetHeight());
}

vec2 ScreenToML(vec2 screenPos) {
    return (screenToML * screenPos).xy;
}

vec2 MLToScreen(vec2 MLPos) {
    return (mlToScreen * MLPos).xy;
}
