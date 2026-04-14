import React from "react";

function App() {
  // Wersja wczytana z Dockerfile zmienna środowiskowa podczas budowy
  const version = process.env.REACT_APP_VERSION || "Brak wersji";

  // Zmienne od Nginx w momencie startu kontenera
  const hostname = window.location.hostname || "Ładowanie...";
  const adres = window.location.href || "Ładowanie...";

  return (
    <div>
      <p>Hostname: {hostname}</p>
      <p>Adres: {adres}</p>
      <p>Wersja aplikacji: {version}</p>
    </div>
  );
}

export default App;
