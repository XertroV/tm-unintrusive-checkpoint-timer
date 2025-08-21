// Hide the "2nd | 0:30.234" text

[Setting hidden description="This is the part that shows your race rank, e.g., '2nd'"]
bool S_HideCPFrameRaceRank = false;

[Setting hidden description="This is the part that shows the cp time"]
bool S_HideCPFrameRaceTime = false;

[Setting hidden description="This is the part that shows the difference to your PB"]
bool S_HideCPFrameRaceDiff = false;

[Setting hidden description="Hide splits when the Openplanet UI is hidden"]
bool S_HideCPFrameWithOverlay = false;


[SettingsTab name="Hide Elements"]
void Render_ST_HideElements() {
    bool origRank = S_HideCPFrameRaceRank;
    bool origTime = S_HideCPFrameRaceTime;
    bool origDiff = S_HideCPFrameRaceDiff;
    bool origHideWithOverlay = S_HideCPFrameWithOverlay;
    S_HideCPFrameRaceDiff = UI::Checkbox("Hide Diff", S_HideCPFrameRaceDiff);
    AddSimpleTooltip("This is the part that shows the difference to your PB");
    S_HideCPFrameRaceTime = UI::Checkbox("Hide Time", S_HideCPFrameRaceTime);
    AddSimpleTooltip("This is the part that shows the cp time");
    S_HideCPFrameRaceRank = UI::Checkbox("Hide Rank", S_HideCPFrameRaceRank);
    AddSimpleTooltip("This is the part that shows your race rank, e.g., '2nd'");
    S_HideCPFrameWithOverlay = UI::Checkbox("Hide Splits When Overlay Hidden", S_HideCPFrameWithOverlay);
    AddSimpleTooltip("Hide splits when the Openplanet UI is hidden.");
    if (origRank != S_HideCPFrameRaceRank
        || origTime != S_HideCPFrameRaceTime
        || origDiff != S_HideCPFrameRaceDiff
        || origHideWithOverlay != S_HideCPFrameWithOverlay
    ) {
        UpdateCPFramePreferences();
    }
}

void UpdateCPFramePreferences() {
    bool hideWOverlay = S_HideCPFrameWithOverlay && !UI::IsOverlayShown();
    CheckUpdateVisibility(CPFrameRaceDiff, S_HideCPFrameRaceDiff || hideWOverlay);
    CheckUpdateVisibility(CPFrameRaceTime, S_HideCPFrameRaceTime || hideWOverlay);
    CheckUpdateVisibility(CPFrameRaceRank, S_HideCPFrameRaceRank || hideWOverlay);
}

void ResetCPFrameVisibility() {
    if (CPFrameRaceDiff !is null) {
        CPFrameRaceDiff.Visible = true;
    }
    if (CPFrameRaceTime !is null) {
        CPFrameRaceTime.Visible = true;
    }
    if (CPFrameRaceRank !is null) {
        CPFrameRaceRank.Visible = true;
    }
}

void WatchForCpFrameChangeOfVis() {
    while (true) {
        yield();
        if (!CanAccessMLElements) { sleep(100); continue; };
        bool shouldHide = S_HideCPFrameWithOverlay && !UI::IsOverlayShown();
        CheckUpdateVisibility(CPFrameRaceDiff, S_HideCPFrameRaceDiff || shouldHide);
        CheckUpdateVisibility(CPFrameRaceTime, S_HideCPFrameRaceTime || shouldHide);
        CheckUpdateVisibility(CPFrameRaceRank, S_HideCPFrameRaceRank || shouldHide);
    }
}

void CheckUpdateVisibility(CGameManialinkFrame@ frame, bool hidden = false) {
    if (frame is null) return;
    frame.Visible = !hidden;
}
