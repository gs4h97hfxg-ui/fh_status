const healthBar = document.querySelector('.health span');
const armorBar = document.querySelector('.armor span');
const staminaBar = document.querySelector('.stamina span');

const cashEl = document.getElementById('cash');
const bankEl = document.getElementById('bank');

const serverNameEl = document.getElementById('serverName');
const playerIdEl = document.getElementById('playerId');

const vehiclePanel = document.querySelector('.vehicle');
const speedEl = document.getElementById('speed');
const fuelEl = document.getElementById('fuel');
const rpmEl = document.getElementById('rpm');

const voiceEl = document.getElementById('voice');

window.addEventListener('message', (e) => {
  const data = e.data;

  switch (data.type) {

    case 'hud:init':
      serverNameEl.textContent = data.serverName;
      playerIdEl.textContent = data.playerId;
      break;

    case 'hud:money':
      cashEl.textContent = data.cash;
      bankEl.textContent = data.bank;
      break;

    case 'hud:status':
      healthBar.style.width = `${data.health}%`;
      armorBar.style.width = `${data.armor}%`;
      staminaBar.style.width = `${data.stamina}%`;

      voiceEl.classList.toggle('active', data.talking);
      break;

    case 'hud:vehicle':
      if (!data.inVehicle) {
        vehiclePanel.classList.add('hidden');
        return;
      }

      vehiclePanel.classList.remove('hidden');
      speedEl.textContent = data.speed;
      fuelEl.textContent = Math.floor(data.fuel);
      rpmEl.textContent = data.rpm;
      break;
  }
});
