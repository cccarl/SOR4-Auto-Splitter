state("SOR4", "V05-s r11096"){
    int submenusOpen : 0x01444058, 0x0, 0x68, 0x28;
    int currentSectionFrames : 0x01448B00, 0x90, 0x30;
    int totalFrameCount : 0x01448B00, 0xA8, 0x28;
}

startup{
    settings.Add("gameTimeMsg", true, "Ask if Game Time should be used when the game opens");

    vars.gameTimeUpdateStopwatch = new Stopwatch();
    vars.gameTimeUpdateStopwatch.Start();
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
    vars.updatedGameTime = vars.gameTime;
}

update{
    vars.updatedGameTime = (current.currentSectionFrames + current.totalFrameCount) * 1000/60;
    // gameTime updates when the new update is in a reasonable range (in case the pointers show bad data), or if there hasn't been an update for 1 second (in a reset or in the rare case it's stuck)
    if (vars.gameTime + 1000 > vars.updatedGameTime && vars.gameTime - 1000 < vars.updatedGameTime || vars.gameTimeUpdateStopwatch.ElapsedMilliseconds > 1000){
        vars.gameTime = vars.updatedGameTime;
        vars.gameTimeUpdateStopwatch.Restart();
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
}