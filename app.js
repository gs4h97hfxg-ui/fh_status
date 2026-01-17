const healthBar = document.querySelector(".health span");
const armorBar = document.querySelector(".armor span");
const hungerBar = document.querySelector(".hunger span");
const thirstBar = document.querySelector(".thirst span");

const cashEl = document.getElementById("cash");
const bankEl = document.getElementById("bank");

const serverNameEl = document.getElementById("serverName");
const playerIdEl = document.getElementById("playerId");

const vehiclePanel = document.getElementById("vehicle");
const speedEl = document.getElementById("speed");
const fuelRing = document.getElementById("fuelRing");

const voiceEl = document.getElementById("voice");

window.addEventListener("message", (e) => {
  const data = e.data;

  switch (data.type) {
    case "hud:init":
      serverNameEl.textContent = data.serverName;
      playerIdEl.textContent = data.playerId;
      break;

    case "hud:money":
      cashEl.textContent = data.cash;
      bankEl.textContent = data.bank;
      break;

    case "hud:status":
      healthBar.style.width = `${data.health}%`;
      armorBar.style.width = `${data.armor}%`;
      hungerBar.style.width = `${data.hunger}%`;
      thirstBar.style.width = `${data.thirst}%`;

      voiceEl.classList.toggle("active", data.talking);
      break;

    case "hud:vehicle":
      if (!data.inVehicle) {
        vehiclePanel.classList.add("hidden");
        return;
      }

      vehiclePanel.classList.remove("hidden");
      speedEl.textContent = data.speed;

      // Update Fuel Ring (Length of arc is 99)
      const fuelLevel = Math.max(0, Math.min(100, data.fuel));
      const offset = 99 - (fuelLevel / 100) * 99;
      fuelRing.style.strokeDashoffset = offset;

      // Color coding fuel
      if (fuelLevel < 10) fuelRing.style.stroke = "#e74c3c"; // Red
      else if (fuelLevel < 35) fuelRing.style.stroke = "#e67e22"; // Orange
      else fuelRing.style.stroke = "#f1c40f"; // Yellow
      break;
  }
});
