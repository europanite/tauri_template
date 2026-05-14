import { useState } from 'react';
import { invoke } from '@tauri-apps/api/core';

export default function App() {
  const [message, setMessage] = useState('Ready');

  async function checkNativeBridge() {
    const result = await invoke<string>('app_health');
    setMessage(result);
  }

  return (
    <main className="shell">
      <section className="card">
        <p className="eyebrow">Tauri v2 / React / Vite</p>
        <h1>Continuous Release Template</h1>
        <p className="lead">
          Replace this screen with the first useful workflow of your paid desktop app.
        </p>
        <div className="actions">
          <button type="button" onClick={checkNativeBridge}>
            Check Rust bridge
          </button>
        </div>
        <p className="status">Status: {message}</p>
      </section>
    </main>
  );
}
