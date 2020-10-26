state("SOR4", "V05-s r11096"){
    int submenusOpen : 0x01444058, 0x0, 0x68, 0x28;
    int currentSectionFrames : 0x01448B00, 0x90, 0x30;
    int totalFrameCount : 0x01448B00, 0xA8, 0x28;
}

startup{
    settings.Add("gameTimeMsg", true, "Ask if Game Time should be used when the game opens");
    settings.Add("splits", false, "Auto Splits");
    settings.SetToolTip("splits", "NOTE: These splits only fit for full game runs since they work by counting loading screens after the IGT starts."+
    "\nFor example, while doing a run of Y Island from Stage Select and getting to the third loading screen, the Diva split will be triggered.");

    string[] stageNames = new string[12] {"The Streets", "Police Precinct", "Cargo Ship", "Old Pier", "Underground", "Chinatown", "Skytrain", "Art Gallery", "Y Tower", "To The Concert", "Airplane", "Y Island"};
    for (int i = 1; i <= 12; i++){
        settings.Add("splits_stage_" + i.ToString(), true, "Stage " + i.ToString() + " - " + stageNames[i-1], "splits");
    }
    settings.Add("splits_id1", false, "Streets", "splits_stage_1");
    settings.Add("splits_id2", false, "Electric Streets", "splits_stage_1");
    settings.Add("splits_id3", true, "Diva", "splits_stage_1");
    settings.Add("splits_id4", false, "Jail", "splits_stage_2");
    settings.Add("splits_id5", false, "HQ", "splits_stage_2");
    settings.Add("splits_id6", true, "Commissioner", "splits_stage_2");
    settings.Add("splits_id7", false, "Outside", "splits_stage_3");
    settings.Add("splits_id8", false, "Inside", "splits_stage_3");
    settings.Add("splits_id9", false, "Hallway", "splits_stage_3");
    settings.Add("splits_id10", true, "Nora", "splits_stage_3");
    settings.Add("splits_id11", false, "Pier", "splits_stage_4");
    settings.Add("splits_id12", true, "Estel", "splits_stage_4");
    settings.Add("splits_id13", false, "Underground", "splits_stage_5");
    settings.Add("splits_id14", false, "Bar", "splits_stage_5");
    settings.Add("splits_id15", true, "Barbon", "splits_stage_5");
    settings.Add("splits_id16", false, "Streets", "splits_stage_6");
    settings.Add("splits_id17", false, "Dojo - Galsia Room", "splits_stage_6");
    settings.Add("splits_id18", false, "Dojo - Donovan Room", "splits_stage_6");
    settings.Add("splits_id19", false, "Dojo - Pheasant Room", "splits_stage_6");
    settings.Add("splits_id20", true, "Shiva", "splits_stage_6");
    settings.Add("splits_id21", true, "Estel", "splits_stage_7");
    settings.Add("splits_id22", false, "Gallery", "splits_stage_8");
    settings.Add("splits_id23", true, "Beyo and Riha", "splits_stage_8");
    settings.Add("splits_id24", false, "Sauna", "splits_stage_9");
    settings.Add("splits_id25", false, "Elevator", "splits_stage_9");
    settings.Add("splits_id26", true, "Max", "splits_stage_9");
    settings.Add("splits_id27", false, "Rooftops - Arrival", "splits_stage_10");
    settings.Add("splits_id28", false, "Rooftops - Advance", "splits_stage_10");
    settings.Add("splits_id29", false, "Rooftops - Wrecking Balls", "splits_stage_10");
    settings.Add("splits_id30", true, "DJ K-Washi", "splits_stage_10");
    settings.Add("splits_id31", false, "Platform ", "splits_stage_11");
    settings.Add("splits_id32", false, "Boarding the Airplane", "splits_stage_11");
    settings.Add("splits_id33", false, "Inside the Airplane", "splits_stage_11");
    settings.Add("splits_id34", true, "Mr. Y", "splits_stage_11");
    settings.Add("splits_id35", false, "Wreckage", "splits_stage_12");
    settings.Add("splits_id36", false, "Entering Castle", "splits_stage_12");
    settings.Add("splits_id37", false, "Inside Castle", "splits_stage_12");
    settings.Add("splits_id38", false, "Ms. Y", "splits_stage_12");
    settings.Add("splits_id39", true, "Ms. Y, Mr. Y and Y Mecha", "splits_stage_12");


    vars.gameTimeUpdateStopwatch = new Stopwatch();
    vars.gameTimeUpdateStopwatch.Start();
    vars.splitsDelay = new Stopwatch(); // slight splits delay to make sure it's done when the IGT is fully stopped
    vars.totalFrameCounterUpdates = 0; // serves as a split ID depending on how many times totalFrameCount has been updated (in every laoding screen and end of stage)
    vars.totalFrameCountBackup = 0; // saves current value of the total frame counter when it goes up
    vars.splitNow = false;

    vars.splitActions = (EventHandler)((s, e) => {
        vars.splitNow = false;
        vars.splitsDelay.Reset();
    });
    timer.OnSplit += vars.splitActions;

}

init{
    if (timer.CurrentTimingMethod == TimingMethod.RealTime && settings["gameTimeMsg"]){
        var message = MessageBox.Show(
            "Would you like to change the current timing method to\nGame Time instead of Real Time?", 
            "LiveSplit | SOR4 Auto Splitter", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

        if (message == DialogResult.Yes){
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    switch (modules.First().ModuleMemorySize) {
        case 0x15B1000: version = "V05-s r11096"; break;
        default: version = "Not Supported"; break;
    }

    vars.gameTime = (current.currentSectionFrames + current.totalFrameCount) * 1000/60;
}

update{

    vars.updatedGameTime = (current.currentSectionFrames + current.totalFrameCount) * 1000/60;
    // gameTime updates when the new update is in a reasonable range (in case the pointers show bad data), when the update time is a lower number than gameTime and 0.5 have passed without an update (reset), or when the update time is a higher number than gameTime and 10 have passed without an update (stuck, rare)
    if (vars.gameTime + 1000 > vars.updatedGameTime && vars.gameTime - 1000 < vars.updatedGameTime || vars.gameTimeUpdateStopwatch.ElapsedMilliseconds > 500 && vars.updatedGameTime < vars.gameTime || vars.gameTimeUpdateStopwatch.ElapsedMilliseconds > 10000 && vars.updatedGameTime > vars.gameTime){
        vars.gameTime = vars.updatedGameTime;
        vars.gameTimeUpdateStopwatch.Restart();

        // variables for splitting update when gameTime updates and the total frames counter updates (using a backup variable to avoid reading bad data)
        if (old.totalFrameCount != 0 && current.totalFrameCount > vars.totalFrameCountBackup || vars.totalFrameCounterUpdates == 0 && current.totalFrameCount != 0 && old.totalFrameCount == 0){
            vars.totalFrameCounterUpdates += 1;
            vars.totalFrameCountBackup = current.totalFrameCount;
            vars.splitNow = true;
            vars.splitsDelay.Start();
        }

        // split variables reset when the IGT starts from 0
        if (current.currentSectionFrames > 0 && current.currentSectionFrames < 60 && current.totalFrameCount == 0){
            vars.totalFrameCounterUpdates = 0;
            vars.totalFrameCountBackup = 0;
            vars.splitNow = false;
        }
    }

}

start{
    return current.currentSectionFrames > 0 && current.currentSectionFrames < 60 && current.totalFrameCount == 0;
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
    return vars.splitNow && settings["splits_id" + vars.totalFrameCounterUpdates] && vars.splitsDelay.ElapsedMilliseconds > 51;
}

shutdown {
    timer.OnSplit -= vars.splitActions;
}