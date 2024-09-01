function loadFanControl() {
    progress.innerHTML = "Fan Control loading... please wait";
    injectPayload(`fan${tempC.value}.bin.bz2`);
}

function setTemperatureOptions() {
    const select = document.getElementById("tempC");
    for (let i = 50; i <= 80; i += 5) {
       const option = document.createElement("option");
       option.text = i;
       option.value = i;
       select.add(option);
    }
    select.value = 60;
    localStorage.setItem("fanthreshold", select.value);
}

document.addEventListener("DOMContentLoaded", setTemperatureOptions);