// Hide the "2nd | 0:30.234" text

[Setting hidden]
bool S_HideCPFrameRaceRank = false;

[Setting hidden]
bool S_HideCPFrameRaceTime = false;

[Setting hidden]
bool S_HideCPFrameRaceDiff = false;


[SettingsTab name="Hide Elements"]
void Render_ST_HideElements() {
    bool origRank = S_HideCPFrameRaceRank;
    bool origTime = S_HideCPFrameRaceTime;
    bool origDiff = S_HideCPFrameRaceDiff;
    S_HideCPFrameRaceDiff = UI::Checkbox("Hide Diff", S_HideCPFrameRaceDiff);
    AddSimpleTooltip("This is the part that shows the difference to your PB");
    S_HideCPFrameRaceTime = UI::Checkbox("Hide Time", S_HideCPFrameRaceTime);
    AddSimpleTooltip("This is the part that shows the cp time");
    S_HideCPFrameRaceRank = UI::Checkbox("Hide Rank", S_HideCPFrameRaceRank);
    AddSimpleTooltip("This is the part that shows your race rank, e.g., '2nd'");
    if (origRank != S_HideCPFrameRaceRank || origTime != S_HideCPFrameRaceTime || origDiff != S_HideCPFrameRaceDiff) {
        UpdateCPFramePreferences();
    }
}

void UpdateCPFramePreferences() {
    if (CPFrameRaceDiff !is null) {
        CPFrameRaceDiff.Visible = !S_HideCPFrameRaceDiff;
    }
    if (CPFrameRaceTime !is null) {
        CPFrameRaceTime.Visible = !S_HideCPFrameRaceTime;
    }
    if (CPFrameRaceRank !is null) {
        CPFrameRaceRank.Visible = !S_HideCPFrameRaceRank;
    }
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
        if (CPFrameRaceDiff !is null && S_HideCPFrameRaceDiff && CPFrameRaceDiff.Visible) {
            CPFrameRaceDiff.Visible = !S_HideCPFrameRaceDiff;
        }
        if (CPFrameRaceTime !is null && S_HideCPFrameRaceTime && CPFrameRaceTime.Visible) {
            CPFrameRaceTime.Visible = !S_HideCPFrameRaceTime;
        }
        if (CPFrameRaceRank !is null && S_HideCPFrameRaceRank && CPFrameRaceRank.Visible) {
            CPFrameRaceRank.Visible = !S_HideCPFrameRaceRank;
        }
    }
}
