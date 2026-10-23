(() => {
  const $ = (id) => document.getElementById(id);

  function escapeHtml(s) {
    return String(s ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;");
  }

  function statusClass(st) {
    if (st === "success") return "status-ok";
    if (st === "fail") return "status-fail";
    return "status-partial";
  }

  async function load() {
    const res = await fetch("/api/status");
    const data = await res.json();
    const cards = $("exchange-cards");
    const totalCard = `
      <div class="card">
        <div class="card-title">Всего сделок в БД</div>
        <div class="card-value">${Number(data.total_trades).toLocaleString("ru-RU")}</div>
        <div class="card-note">Серверное время (UTC): ${escapeHtml(data.server_time || "—")}</div>
      </div>`;
    const exCards = (data.exchanges || [])
      .map(
        (ex) => `
      <div class="card">
        <div class="card-title">${escapeHtml(ex.name)} (${escapeHtml(ex.code)})</div>
        <div class="card-value">${Number(ex.count).toLocaleString("ru-RU")}</div>
        <div class="card-note">
          Последняя дата торгов: ${escapeHtml(ex.last_trade_date || "—")}<br/>
          Обновление в БД: ${escapeHtml(ex.last_updated_at || "—")}
        </div>
      </div>`
      )
      .join("");
    cards.innerHTML = totalCard + exCards;

    const body = $("runs-body");
    if (!data.last_runs || !data.last_runs.length) {
      body.innerHTML = `<tr><td colspan="9" class="empty">Запусков ещё не было</td></tr>`;
      return;
    }
    body.innerHTML = data.last_runs
      .map(
        (r) => `<tr>
        <td>${r.id}</td>
        <td>${escapeHtml(r.source)}</td>
        <td>${escapeHtml(r.mode)}</td>
        <td class="${statusClass(r.status)}">${escapeHtml(r.status)}</td>
        <td class="mono">${escapeHtml(r.started_at || "—")}</td>
        <td class="mono">${escapeHtml(r.finished_at || "—")}</td>
        <td class="mono">${r.records_added}</td>
        <td class="mono">${r.records_seen}</td>
        <td class="cell-muted">${escapeHtml(r.error_text || "")}</td>
      </tr>`
      )
      .join("");
  }

  $("btn-refresh").addEventListener("click", load);
  $("btn-parse-inc").addEventListener("click", async () => {
    $("parse-msg").textContent = "Запуск…";
    const res = await fetch("/api/parse?source=all&mode=incremental", { method: "POST" });
    const data = await res.json();
    $("parse-msg").textContent = data.message || "OK";
    setTimeout(load, 3000);
  });

  load();
  setInterval(load, 15000);
})();
