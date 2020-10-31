// todo list
// stageId has failed, next time i hope to catch it and see if cheat engine gives me a better pointer path -> backup "fixes" that?
// make sure that adding the "current.submenusOpen == 0" condition to update gameTime really fixes the section counter going up when unpausing (sometimes) -> works?
// add splits based on music changing for old pier estel and skytrain stel

state("SOR4", "V05-s r11096"){
    int submenusOpen : 0x01444058, 0x0, 0x68, 0x28;
    int currentSectionFrames : 0x01448B00, 0x90, 0x30;
    int totalFrameCount : 0x01448B00, 0xA8, 0x28;
    string4 stageId : 0x01448B00, 0x98, 0x10, 0x118, 0x10, 0x22; // FAKE ID, it's actually part of the name of the music file at the start of the current section
    string4 stageIdBackup : 0x0144B570, 0x38, 0x30, 0x20, 0x90, 0x20, 0x22; // another fake ID, based on the current music playing
    string100 currentMusic : 0x0144B570, 0x38, 0x30, 0x20, 0x90, 0x20, 0xC;
}

startup{
    settings.Add("gameTimeMsg", true, "Ask if Game Time should be used when the game opens");

    settings.Add("start", true, "Auto Start");
    settings.Add("start_any", true, "Any Stage", "start");
    settings.SetToolTip("start_any", "Also for Boss Rush");
    settings.Add("splits", false, "Auto Splits");

    string[] stageNames = new string[12] {"The Streets", "Police Precinct", "Cargo Ship", "Old Pier", "Underground", "Chinatown", "Skytrain", "Art Gallery", "Y Tower", "To The Concert", "Airplane", "Y Island"};

    for (int i = 1; i <= 12; i++){
        settings.Add("splits_stage_" + i, true, "Stage " + i + " - " + stageNames[i-1], "splits");
        settings.Add("start_" + i, false, "Stage " + i + " - " + stageNames[i-1], "start");
    }
    settings.Add("start_bossRush", false, "Boss Rush", "start");
    settings.Add("splits_id_1_1", false, "Streets", "splits_stage_1");
    settings.Add("splits_id_1_2", false, "Sewers", "splits_stage_1");
    settings.Add("splits_id_1_3", true, "Diva", "splits_stage_1");
    settings.Add("splits_id_2_1", false, "Jail", "splits_stage_2");
    settings.Add("splits_id_2_2", false, "HQ", "splits_stage_2");
    settings.Add("splits_id_2_3", true, "Commissioner", "splits_stage_2");
    settings.Add("splits_id_3_1", false, "Outside", "splits_stage_3");
    settings.Add("splits_id_3_2", false, "Inside", "splits_stage_3");
    settings.Add("splits_id_3_3", false, "Hallway", "splits_stage_3");
    settings.Add("splits_id_3_4", true, "Nora", "splits_stage_3");
    settings.Add("splits_id_4_1", false, "Pier", "splits_stage_4");
    settings.Add("splits_id_4_2", true, "Estel", "splits_stage_4");
    settings.Add("splits_id_5_1", false, "Underground", "splits_stage_5");
    settings.Add("splits_id_5_2", false, "Bar", "splits_stage_5");
    settings.Add("splits_id_5_3", true, "Barbon", "splits_stage_5");
    settings.Add("splits_id_6_1", false, "Streets", "splits_stage_6");
    settings.Add("splits_id_6_2", false, "Dojo - Galsia Room", "splits_stage_6");
    settings.Add("splits_id_6_3", false, "Dojo - Donovan Room", "splits_stage_6");
    settings.Add("splits_id_6_4", false, "Dojo - Pheasant Room", "splits_stage_6");
    settings.Add("splits_id_6_5", true, "Shiva", "splits_stage_6");
    settings.Add("splits_id_7_1", true, "Estel", "splits_stage_7");
    settings.Add("splits_id_8_1", false, "Gallery", "splits_stage_8");
    settings.Add("splits_id_8_2", true, "Beyo and Riha", "splits_stage_8");
    settings.Add("splits_id_9_1", false, "Sauna", "splits_stage_9");
    settings.Add("splits_id_9_2", false, "Elevator", "splits_stage_9");
    settings.Add("splits_id_9_3", true, "Max", "splits_stage_9");
    settings.Add("splits_id_10_1", false, "Rooftops - Arrival", "splits_stage_10");
    settings.Add("splits_id_10_2", false, "Rooftops - Advance", "splits_stage_10");
    settings.Add("splits_id_10_3", false, "Rooftops - Wrecking Balls", "splits_stage_10");
    settings.Add("splits_id_10_4", true, "DJ K-Washi", "splits_stage_10");
    settings.Add("splits_id_11_1", false, "Platform ", "splits_stage_11");
    settings.Add("splits_id_11_2", false, "Boarding the Airplane", "splits_stage_11");
    settings.Add("splits_id_11_3", false, "Inside the Airplane", "splits_stage_11");
    settings.Add("splits_id_11_4", true, "Mr. Y", "splits_stage_11");
    settings.Add("splits_id_12_1", false, "Wreckage", "splits_stage_12");
    settings.Add("splits_id_12_2", false, "Entering Castle", "splits_stage_12");
    settings.Add("splits_id_12_3", false, "Inside Castle", "splits_stage_12");
    settings.Add("splits_id_12_4", false, "Ms. Y", "splits_stage_12");
    settings.Add("splits_id_12_5", true, "Ms. Y, Mr. Y and Y Mecha", "splits_stage_12");
    settings.Add("splits_bossRush", false, "Boss Rush", "splits");
    settings.Add("splits_bossRush_newBoss", false, "Boss Defeated", "splits_bossRush");


    vars.gameTimeUpdateStopwatch = new Stopwatch();
    vars.gameTimeUpdateStopwatch.Start();
    vars.splitsDelay = new Stopwatch(); // slight splits delay to make sure it's done when the IGT is fully stopped
    vars.currentStage = 1;
    vars.currentSectionId = 0; // works as a counter that goes up every loading screen / end of stage
    vars.totalFrameCountBackup = 0; // saves current value of the total frame counter when it goes up
    vars.splitNow = false;
    vars.enteredStages = new bool[12] {false, false, false, false, false, false, false, false, false, false, false, false};

    vars.splitActions = (EventHandler)((s, e) => {
        vars.splitNow = false;
        vars.splitsDelay.Reset();
    });
    timer.OnSplit += vars.splitActions;

    vars.startActions = (EventHandler)((s, e) => {
        vars.currentSectionId = 0;
        vars.enteredStages = new bool[12] {false, false, false, false, false, false, false, false, false, false, false, false};
        vars.enteredStages[vars.currentStage - 1] = true;
    });
    timer.OnStart += vars.startActions;

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







    // updates a text component in the layout, also creates it if it doesn't exist
    Action <string, string> UpdateTextComponent = (string name, string updatedText) => {
        bool foundComponent = false;
        foreach (dynamic component in timer.Layout.Components){
            if (component.GetType().Name != "TextComponent" || component.Settings.Text1 != name) continue;
            component.Settings.Text2 = updatedText;
            foundComponent = true;
            break;
        }
        if (!foundComponent) vars.CreateTextComponent(name, updatedText);
    };
    vars.UpdateTextComponent = UpdateTextComponent;

    // creates a text component, used when UpdateTextComponent doens't find the text component requested
    Action <string, string> CreateTextComponent = (string textLeft, string textRight) => {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        dynamic textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
        textComponent.Settings.Text1 = textLeft;
        textComponent.Settings.Text2 = textRight;
    };
    vars.CreateTextComponent = CreateTextComponent;

}

update{

    vars.updatedGameTime = (current.currentSectionFrames + current.totalFrameCount) * 1000/60;
    // gameTime updates when the new update is in a reasonable range (in case the pointers show bad data), or when gameTime hasn't been updated for a while, also the pause menu open prevents updates (the pointers sometimes mess up while the game is unpausing) 
    if ((vars.gameTime + 1000 > vars.updatedGameTime && vars.gameTime - 1000 < vars.updatedGameTime || vars.gameTimeUpdateStopwatch.ElapsedMilliseconds > 500 && vars.updatedGameTime < vars.gameTime || vars.gameTimeUpdateStopwatch.ElapsedMilliseconds > 10000 && vars.updatedGameTime > vars.gameTime) && current.submenusOpen == 0){
        vars.gameTime = vars.updatedGameTime;
        vars.gameTimeUpdateStopwatch.Restart();

        // variables for splitting update when gameTime updates and the total frames counter updates (using a backup variable to avoid reading bad data)
        if (old.totalFrameCount != 0 && current.totalFrameCount > vars.totalFrameCountBackup || vars.currentSectionId == 0 && current.totalFrameCount != 0 && old.totalFrameCount == 0){
            vars.currentSectionId += 1;

            vars.UpdateTextComponent("section", vars.currentSectionId.ToString());

            vars.totalFrameCountBackup = current.totalFrameCount;
            vars.splitNow = true;
            vars.splitsDelay.Start();
        }

        // split variables reset when the IGT starts from 0
        if (current.currentSectionFrames > 0 && current.currentSectionFrames < 60 && current.totalFrameCount == 0){
            vars.totalFrameCountBackup = 0;
            vars.splitNow = false;
        }
    }

    if (current.stageId != old.stageId || current.stageIdBackup != old.stageIdBackup){
        print("[ASL] LEVEL ID: " + current.stageId);
        print("[ASL] LEVEL ID BACKUP: " + current.stageIdBackup);
        short stageStrToInt = Convert.ToInt16(current.stageId);
        short stageStrToIntBackup = Convert.ToInt16(current.stageIdBackup);
        // during runs stage changes only when it hasn't been entered before
        if (timer.CurrentPhase != TimerPhase.NotRunning){
            if (stageStrToInt >= 1 && stageStrToInt <= 12 && !vars.enteredStages[stageStrToInt - 1]){
                vars.enteredStages[stageStrToInt - 1] = true;
                vars.currentStage = stageStrToInt;
                vars.currentSectionId = 0;
            }
            else if (stageStrToIntBackup >= 1 && stageStrToIntBackup <= 12 && !vars.enteredStages[stageStrToIntBackup - 1]){
                vars.enteredStages[stageStrToIntBackup - 1] = true;
                vars.currentStage = stageStrToIntBackup;
                vars.currentSectionId = 0;
            }
        }
        // outside of runs it will always change
        else{
            if (stageStrToInt >= 1 && stageStrToInt <= 12){
                vars.currentStage = stageStrToInt;
                vars.currentSectionId = 0;
            }
            else if (stageStrToIntBackup >= 1 && stageStrToIntBackup <= 12){
                vars.currentStage = stageStrToIntBackup;
                vars.currentSectionId = 0;
            }
        }
        print("[ASL] CURRENT STAGE VAR: " + vars.currentStage);
        vars.UpdateTextComponent("stage", vars.currentStage.ToString());
        vars.UpdateTextComponent("section", vars.currentSectionId.ToString());
    }

}

start{
    return current.currentSectionFrames > 0 && current.currentSectionFrames < 60 && current.totalFrameCount == 0 && (settings["start_" + vars.currentStage] || (settings["start_bossRush"] && current.currentMusic == "Music_BossRush!A00_Diva") || settings["start_any"]);
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
    return vars.splitNow && settings["splits_id_" + vars.currentStage + "_" + vars.currentSectionId] && vars.splitsDelay.ElapsedMilliseconds > 51
        || current.currentMusic != old.currentMusic && old.currentMusic.Contains("BossRush") && settings["splits_bossRush_newBoss"];
}

shutdown {
    timer.OnSplit -= vars.splitActions;
    timer.OnStart -= vars.startActions;
}