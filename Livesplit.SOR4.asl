state("SOR4", "V05-s r11096"){
    int submenusOpen : 0x01444058, 0x0, 0x68, 0x28;
    int inGameplay : 0x01448B00, 0x8C; // 0 when in a menu / loading screen, around 500 when in a level
    int currentSectionFrames : 0x01448B00, 0x90, 0x30;
    int totalFrameCount : 0x01448B00, 0xA8, 0x28;
}

startup{
    settings.Add("gameTimeMsg", true, "Ask if Game Time should be used when the game opens");
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
    if (current.totalFrameCount < 0 || current.currentSectionFrames <= 0){
        return true;
    }
    if ((current.inGameplay == 0 && current.totalFrameCount != 0) || (current.totalFrameCount > old.totalFrameCount)){
        vars.gameTime = current.totalFrameCount * 1000/60;
    }
    else if (current.inGameplay != 0 && old.currentSectionFrames != current.currentSectionFrames && old.currentSectionFrames + 60 > current.currentSectionFrames){
        vars.gameTime = (current.currentSectionFrames + current.totalFrameCount) * 1000/60;
    }
}

start{
    return current.currentSectionFrames > 0 && current.currentSectionFrames < 60;
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