const string CheckpointPageName = "UIModule_Race_Checkpoint";
bool CanAccessMLElements = false;

void CMapLoop() {
    auto app = cast<CGameManiaPlanet>(GetApp());
    auto net = app.Network;
    while (true) {
        yield();
        CanAccessMLElements = false;
        while (net.ClientManiaAppPlayground is null) yield();
        AwaitGetMLObjs();
        CanAccessMLElements = true;
        while (net.ClientManiaAppPlayground !is null) yield();
        @CheckpointsFrame = null;
        @CPFrameRaceRank = null;
        @CPFrameRaceDiff = null;
        @CPFrameRaceTime = null;
    }
}


// MainFrame.Controls[0].Controls[0].Controls[0] -- "frame-checkpoint"

CGameManialinkFrame@ CheckpointsFrame = null;
CGameManialinkFrame@ CPFrameRaceRank = null;
CGameManialinkFrame@ CPFrameRaceDiff = null;
CGameManialinkFrame@ CPFrameRaceTime = null;
vec2 OrigCpFramePos;

void AwaitGetMLObjs() {
    auto net = cast<CTrackManiaNetwork>(GetApp().Network);
    if (net.ClientManiaAppPlayground is null) throw('null cmap');
    auto cmap = net.ClientManiaAppPlayground;
    while (cmap.UILayers.Length < 7) yield();
    while (CheckpointsFrame is null) {
        yield();
        for (uint i = 0; i < cmap.UILayers.Length; i++) {
            auto layer = cmap.UILayers[i];
            if (!layer.IsLocalPageScriptRunning || !layer.IsVisible || layer.LocalPage is null) continue;
            // auto frame = cast<CGameManialinkFrame>(layer.LocalPage.GetFirstChild("frame-checkpoint"));
            auto frame = cast<CGameManialinkFrame>(layer.LocalPage.GetFirstChild("Race_Checkpoint"));
            if (frame is null) continue;
            @CheckpointsFrame = frame;
            @CPFrameRaceRank = cast<CGameManialinkFrame>(frame.GetFirstChild("frame-race-rank"));
            @CPFrameRaceDiff = cast<CGameManialinkFrame>(frame.GetFirstChild("frame-race-diff"));
            @CPFrameRaceTime = cast<CGameManialinkFrame>(frame.GetFirstChild("frame-race-time"));
            OrigCpFramePos = CheckpointsFrame.RelativePosition_V3;
            UpdateCPFramePreferences();
            break;
        }
    }
    startnew(WatchForIntrusiveCPFrame);
}

vec3 g_CamDir = vec3(1, 1, 1);
vec3 g_CamVelDir = vec3(1, 1, 1);

void WatchForIntrusiveCPFrame() {
    auto app = cast<CTrackMania>(GetApp());
    auto net = cast<CTrackManiaNetwork>(app.Network);

    while (net.ClientManiaAppPlayground !is null && CheckpointsFrame !is null) {
        yield();
        if (!ShowWindow) continue;
        auto cam = Camera::GetCurrent();
        if (cam is null) continue;

        // auto loc = mat4(cam.NextLocation);
        // auto R_T = mat4::Translate(Camera::GetCurrentPosition() * -1) * loc;
        // vec4 dir = (R_T * vec3(0, 0, -1));
        // g_CamDir = dir.xyz * -1;
        // g_CamVelDir = cam.Vel.LengthSquared() > .01 ? cam.Vel.Normalized() : g_CamDir;

        // if (app.GameScene is null) continue;
        // auto player = VehicleState::GetViewingPlayer();
        // if (player is null) continue;
        // auto vis = VehicleState::GetVis(app.GameScene, player);
        // if (vis is null) continue;
        // auto speed = 3.6 * vis.AsyncState.WorldVel.Length();

        auto speed = 0;
        float t = Math::Clamp(Math::InvLerp(300., 700., speed), 0., 1.);
        // can occasionally be null due to yield, but we need the yield before the continues;
        if (CheckpointsFrame !is null) {
            if (S_EnableCustomPos) {
                CheckpointsFrame.RelativePosition_V3 = S_CustomPos;
            } else {
                CheckpointsFrame.RelativePosition_V3 = OrigCpFramePos + vec2(0., 21.5) + Math::Lerp(vec2(0.), vec2(0., 20.), t);
            }
        }
    }
}


/**
 * cam dir notes:
 *
 * fast reactor water, formula surf, totd 2022-11-01
 * Cam1: starts about -.2 y component
 * after -.35 it's in the way.
 * idea: check velocity direction against pointing direction, and if there is > .35 between them, engage.
 *
 *
 *
 */


// void Render() {
//     if (CheckpointsFrame is null) return;
//     auto app = GetApp();
//     if (app.GameScene is null) return;

//     auto player = VehicleState::GetViewingPlayer();
//     if (player is null) return;
//     auto vis = VehicleState::GetVis(GetApp().GameScene, player);
//     if (vis is null) return;

//     auto pos = vis.AsyncState.Position + vec3(0, 1, 0);
//     auto pos2 = pos + 4. * g_CamDir * vec3(-1, 0, 1);
//     auto scr1 = Camera::ToScreen(pos);
//     auto scr2 = Camera::ToScreen(pos2);
//     // can't draw
//     if (scr1.z > 0 || scr1.z > 0) return;

//     float t = Math::InvLerp(.3, .5, g_CamVelDir.y - g_CamDir.y); // g_CamVelDir.LengthSquared() > .2 ?

//     // trace('drawing');

//     nvg::Reset();
//     nvg::BeginPath();
//     nvg::StrokeColor(vec4(t,0,0,1));
//     nvg::StrokeWidth(10);
//     nvg::MoveTo(scr1.xy);
//     nvg::LineTo(scr2.xy);
//     nvg::Stroke();
//     nvg::ClosePath();
// }
