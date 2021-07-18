state("SOR4", "V07-s r13031"){
    int submenusOpen : 0x014C1A90, 0x0, 0x78, 0x28;
    int currentSectionFrames : 0x014C1E08, 0x0, 0xB8, 0x38;
    int totalFrameCount : 0x014C1E18, 0x0, 0x78, 0x10, 0x2C;
    string100 currentMusic : 0x014C1E10, 0x0, 0x90, 0x28, 0xC; // Needs more testing
    string40 levelName : 0x014C1E10, 0x0, 0x90, 0x18, 0x108, 0x3E;
}

state("SOR4", "V05-s r11096"){
    int submenusOpen : 0x01444058, 0x0, 0x68, 0x28;
    int currentSectionFrames : 0x01448B00, 0x90, 0x30;
    int totalFrameCount : 0x01448B00, 0xA8, 0x28;
    string100 currentMusic : 0x0144B570, 0x38, 0x30, 0x20, 0x90, 0x20, 0xC;
    string40 levelName : 0x01443878, 0x0, 0x60, 0x8, 0x28, 0x10, 0x88, 0x3E;
}

state("SOR4", "V04-s r10977"){
    int submenusOpen : 0x014349D8, 0x0, 0x68, 0x28;
    int currentSectionFrames : 0x01439470, 0x90, 0x30;
    int totalFrameCount : 0x01439470, 0xA0, 0x48;
    string100 currentMusic : 0x01439470, 0x90, 0x20, 0xC;
    string40 levelName : 0x01439470, 0x98, 0x10, 0x110, 0x3E;
}

startup{
    settings.Add("gameTimeMsg", true, "Ask if Game Time should be used when the game opens");

    settings.Add("start", true, "Auto Start");
    settings.Add("start_any", true, "Any Stage (Only option available for V07 for now)", "start");
    settings.SetToolTip("start_any", "Also for Boss Rush");
    settings.Add("splits", true, "Auto Splits");

    string[] stageNames = new string[12] {"The Streets", "Police Precinct", "Cargo Ship", "Old Pier", "Underground", "Chinatown", "Skytrain", "Art Gallery", "Y Tower", "To The Concert", "Airplane", "Y Island"};

    for (int i = 1; i <= 12; i++){
        settings.Add("splits_stage" + i, true, "Stage " + i + " - " + stageNames[i-1], "splits");
        if (i == 3 || i == 10){
            settings.Add("start_stage" + i + "_1a", false, "Stage " + i + " - " + stageNames[i-1], "start");
        }
        else{
            settings.Add("start_stage" + i + "_1", false, "Stage " + i + " - " + stageNames[i-1], "start");
        }
    }

    settings.Add("start_llenge_01_bossrun_v3", false, "Boss Rush", "start");
    settings.Add("splits_stage1_1", false, "Streets", "splits_stage1");
    settings.Add("splits_stage1_2", false, "Sewers", "splits_stage1");
    settings.Add("splits_stage1_3", true, "Diva", "splits_stage1");
    settings.Add("splits_stage2_1", false, "Jail", "splits_stage2");
    settings.Add("splits_stage2_2", false, "HQ", "splits_stage2");
    settings.Add("splits_stage2_3", true, "Commissioner", "splits_stage2");
    settings.Add("splits_stage3_1a", false, "Outside", "splits_stage3");
    settings.Add("splits_stage3_1b", false, "Inside", "splits_stage3");
    settings.Add("splits_stage3_1c", false, "Hallway", "splits_stage3");
    settings.Add("splits_stage3_2", true, "Nora", "splits_stage3");
    settings.Add("splits_stage4_1", false, "Pier", "splits_stage4");
    settings.Add("splits_stage4_bossMusic", false, "Estel Start", "splits_stage4");
    settings.Add("splits_stage4_2", true, "Estel", "splits_stage4");
    settings.Add("splits_stage5_1", false, "Underground", "splits_stage5");
    settings.Add("splits_stage5_2", false, "Bar", "splits_stage5");
    settings.Add("splits_stage5_3", true, "Barbon", "splits_stage5");
    settings.Add("splits_stage6_1", false, "Streets", "splits_stage6");
    settings.Add("splits_stage6_2a", false, "Dojo - Galsia Room", "splits_stage6");
    settings.Add("splits_stage6_2b", false, "Dojo - Donovan Room", "splits_stage6");
    settings.Add("splits_stage6_2c", false, "Dojo - Pheasant Room", "splits_stage6");
    settings.Add("splits_stage6_3", true, "Shiva", "splits_stage6");
    settings.Add("splits_stage7_bossMusic", false, "Estel Start", "splits_stage7");
    settings.Add("splits_stage7_1", true, "Estel", "splits_stage7");
    settings.Add("splits_stage8_1", false, "Gallery", "splits_stage8");
    settings.Add("splits_stage8_2", true, "Beyo and Riha", "splits_stage8");
    settings.Add("splits_stage9_1", false, "Sauna", "splits_stage9");
    settings.Add("splits_stage9_2", false, "Elevator", "splits_stage9");
    settings.Add("splits_stage9_3", true, "Max", "splits_stage9");
    settings.Add("splits_stage10_1a", false, "Rooftops - Arrival", "splits_stage10");
    settings.Add("splits_stage10_1b", false, "Rooftops - Advance", "splits_stage10");
    settings.Add("splits_stage10_1c", false, "Rooftops - Wrecking Balls", "splits_stage10");
    settings.Add("splits_stage10_3", true, "DJ K-Washi", "splits_stage10");
    settings.Add("splits_stage11_1", false, "Platform ", "splits_stage11");
    settings.Add("splits_stage11_2a", false, "Boarding the Airplane", "splits_stage11");
    settings.Add("splits_stage11_2b", false, "Inside the Airplane", "splits_stage11");
    settings.Add("splits_stage11_3", true, "Mr. Y", "splits_stage11");
    settings.Add("splits_stage12_1", false, "Wreckage", "splits_stage12");
    settings.Add("splits_stage12_2a", false, "Entering Castle", "splits_stage12");
    settings.Add("splits_stage12_2b", false, "Inside Castle", "splits_stage12");
    settings.Add("splits_stage12_2c", false, "Ms. Y", "splits_stage12");
    settings.Add("splits_stage12_3", true, "Ms. Y, Mr. Y and Y Mecha", "splits_stage12");
    settings.Add("splits_bossRush", true, "Boss Rush", "splits");
    settings.Add("splits_bossRush_newBoss", false, "Boss Defeated", "splits_bossRush");
    settings.Add("splits_llenge_01_bossrun_v3", true, "Boss Rush Completed", "splits_bossRush");


    vars.timerModel = new TimerModel { CurrentState = timer }; // to use the undo split function
    vars.gameTimeUpdateStopwatch = new Stopwatch();
    vars.gameTimeUpdateStopwatch.Start();
    vars.undoSplitStopwatch = new Stopwatch();
    vars.undoSplitStopwatch.Start();
    vars.splitNow = false;
    vars.totalFrameCountBackup = 0; // saves current value of the total frame counter when it goes up
    vars.currentLevel = "";

    vars.startActions = (EventHandler)((s, e) => {
        vars.totalFrameCountBackup = 0;
    });
    timer.OnStart += vars.startActions;

    vars.splitActions = (EventHandler)((s, e) => {
        vars.undoSplitStopwatch.Restart();
    });
    timer.OnSplit += vars.splitActions;
}

init{

    // MD5 code by CptBrian.
    string MD5Hash;
    using (var md5 = System.Security.Cryptography.MD5.Create())
        using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            MD5Hash = md5.ComputeHash(s).Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);

    switch (MD5Hash) {
	case "C8C37201A021AF3916E4109D49E53F2C": version = "V07-s r13031"; break;
        case "5D6586DFD557C55CCBEF526AA76540A2": version = "V05-s r11096"; break;
        case "CB932B1FC191DCD442BA5381BE58C8D7": version = "V04-s r10977"; break;
        default: version = "Not Supported"; break;
    }

    if (timer.CurrentTimingMethod == TimingMethod.RealTime && settings["gameTimeMsg"] && version != "Not Supported"){
        var message = MessageBox.Show(
            "Would you like to change the current timing method to\nGame Time instead of Real Time?", 
            "LiveSplit | SOR4 Auto Splitter", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

        if (message == DialogResult.Yes){
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    vars.gameTime = (current.currentSectionFrames + current.totalFrameCount) * 1000/60;
}

update{
    // very rarely a wrong split is triggered when pausing the game, this undoes it
    if (vars.undoSplitStopwatch.ElapsedMilliseconds < 150 && current.submenusOpen != 0 && old.submenusOpen == 0){
        vars.timerModel.UndoSplit();
        print("ASL Split Undone!!!!");
    }

    if (vars.splitNow){
        vars.splitNow = false;
    }

    vars.updatedGameTime = (current.currentSectionFrames + current.totalFrameCount) * 1000/60;
    // gameTime updates when the new update is in a reasonable range (in case the pointers show bad data), or when gameTime hasn't been updated for a while
    if (vars.gameTime + 1000 > vars.updatedGameTime && vars.gameTime - 1000 < vars.updatedGameTime || vars.gameTimeUpdateStopwatch.ElapsedMilliseconds > 500 && vars.updatedGameTime < vars.gameTime || vars.gameTimeUpdateStopwatch.ElapsedMilliseconds > 10000 && vars.updatedGameTime > vars.gameTime){
        vars.gameTime = vars.updatedGameTime;
        vars.gameTimeUpdateStopwatch.Restart();

        // the "total frames counter" backup gets updated when gameTime gets updated and it's lower than the value in memory, this also triggers splits, also the game has to be unpaused (without this, rarely this would trigger splits while unpausing the game)
        if (old.totalFrameCount != 0 && current.totalFrameCount > vars.totalFrameCountBackup && current.submenusOpen == 0){
            vars.totalFrameCountBackup = current.totalFrameCount;
            vars.splitNow = true;
        }
    }

    // the current level is saved here to avoid having a null name screwing up splits
    if (current.levelName != old.levelName && current.levelName != null){
        vars.currentLevel = current.levelName;
    }

}

start{
    return (current.currentSectionFrames > 0 && current.currentSectionFrames < 60 && old.currentSectionFrames < current.currentSectionFrames && current.totalFrameCount == 0 && settings["start_any"]) 
        || (current.levelName != old.levelName && settings["start_" + current.levelName]);
}

reset{
    return current.submenusOpen == 0 && old.submenusOpen == 2;
}

isLoading{
    return true;
}

gameTime{
    return TimeSpan.FromMilliseconds(vars.gameTime);
}

split{
    return vars.splitNow && settings["splits_" + vars.currentLevel]
        || current.currentMusic != old.currentMusic && (old.currentMusic != null && current.currentMusic != null && old.currentMusic.Contains("BossRush") && current.currentMusic.Contains("BossRush") && settings["splits_bossRush_newBoss"]
                                                    || old.currentMusic == "Music_Level04!G00_end" && current.currentMusic == "Music_Level04!BOSS" && settings["splits_stage4_bossMusic"]
                                                    || old.currentMusic == "Music_Level07!C00_LastWave" && current.currentMusic == "Music_Level07!BOSS" && settings["splits_stage7_bossMusic"]);
}

shutdown{
    timer.OnStart -= vars.startActions;
    timer.OnSplit -= vars.splitActions;
}
