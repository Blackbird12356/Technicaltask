(() => {
  const state = {
    page: 1,
    per_page: 50,
    sort_by: "trade_date",
    sort_dir: "desc",
  };

  const $ = (id) => document.getElementById(id);

  function filters() {
    return {
      exchange: $("f-exchange").value,
      date_from: $("f-date-from").value || undefined,
      date_to: $("f-date-to").value || undefined,
      product: $("f-product").value.trim() || undefined,
      participant: $("f-participant").value.trim() || undefined,
      broker: $("f-broker").value.trim() || undefined,
      amount_min: $("f-amount-min").value || undefined,
      amount_max: $("f-amount-max").value || undefined,
      delivery: $("f-delivery").value.trim() || undefined,
      sort_by: state.sort_by,
      sort_dir: state.sort_dir,
      page: state.page,
      per_page: state.per_page,
    };
  }

  function fmtNum(v) {
    if (v === null || v === undefined || v === "") return "—";
    return Number(v).toLocaleString("ru-RU", { maximumFractionDigits: 2 });
  }

  function escapeHtml(s) {
    return String(s ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;");
  }

  function badge(code, name) {
    const cls = code === "ETS" ? "badge-ets" : "badge-caspian";
    return `<span class="badge ${cls}">${escapeHtml(name || code)}</span>`;
  }

  function renderRows(items) {
    const body = $("trades-body");
    if (!items.length) {
      body.innerHTML = `<tr><td colspan="11" class="empty">Нет сделок по выбранным фильтрам</td></tr>`;
      return;
    }
    body.innerHTML = items
      .map((t) => {
        const codes = [t.product_code, t.tnved_code].filter(Boolean).join(" / ") || "—";
        const seller = t.seller_name
          ? `${escapeHtml(t.seller_name)}${t.seller_bin ? `<div class="cell-muted">${escapeHtml(t.seller_bin)}</div>` : ""}`
          : "—";
        const buyer = t.buyer_name
          ? `${escapeHtml(t.buyer_name)}${t.buyer_bin ? `<div class="cell-muted">${escapeHtml(t.buyer_bin)}</div>` : ""}`
          : "—";
        const brokers = [
          t.seller_broker ? `П: ${escapeHtml(t.seller_broker)}` : null,
          t.buyer_broker ? `Пок: ${escapeHtml(t.buyer_broker)}` : null,
        ]
          .filter(Boolean)
          .join("<br>") || "—";
        const volume =
          t.volume != null ? `${fmtNum(t.volume)}${t.unit ? " " + escapeHtml(t.unit) : ""}` : "—";
        const delivery = [t.delivery_place, t.delivery_term].filter(Boolean).join(" · ") || "—";
        return `<tr>
          <td class="mono">${escapeHtml(t.trade_date || "—")}</td>
          <td>${badge(t.exchange_code, t.exchange)}</td>
          <td>${escapeHtml(t.product_name || "—")}</td>
          <td class="cell-muted">${escapeHtml(codes)}</td>
          <td>${seller}</td>
          <td>${buyer}</td>
          <td>${brokers}</td>
          <td class="mono">${volume}</td>
          <td class="mono">${fmtNum(t.price)}</td>
          <td class="mono">${fmtNum(t.amount)}</td>
          <td>${escapeHtml(delivery)}</td>
        </tr>`;
      })
      .join("");
  }

  function updateSortHeaders() {
    document.querySelectorAll("th[data-sort]").forEach((th) => {
      th.classList.remove("sorted-asc", "sorted-desc");
      if (th.dataset.sort === state.sort_by) {
        th.classList.add(state.sort_dir === "asc" ? "sorted-asc" : "sorted-desc");
      }
    });
  }

  async function load() {
    const params = new URLSearchParams();
    const f = filters();
    Object.entries(f).forEach(([k, v]) => {
      if (v !== undefined && v !== null && v !== "") params.set(k, v);
    });
    $("result-meta").textContent = "Загрузка…";
    const res = await fetch("/api/trades?" + params.toString());
    const data = await res.json();
    renderRows(data.items || []);
    $("result-meta").textContent = `Найдено: ${data.total.toLocaleString("ru-RU")}`;
    $("page-info").textContent = `Стр. ${data.page} из ${data.pages}`;
    $("btn-prev").disabled = data.page <= 1;
    $("btn-next").disabled = data.page >= data.pages;
    updateSortHeaders();
  }

  function debounce(fn, ms) {
    let t;
    return (...args) => {
      clearTimeout(t);
      t = setTimeout(() => fn(...args), ms);
    };
  }

  const reloadFromStart = () => {
    state.page = 1;
    load();
  };
  const debounced = debounce(reloadFromStart, 350);

  $("btn-apply").addEventListener("click", reloadFromStart);
  $("btn-reset").addEventListener("click", () => {
    ["f-exchange", "f-date-from", "f-date-to", "f-product", "f-participant", "f-broker", "f-amount-min", "f-amount-max", "f-delivery"].forEach((id) => {
      const el = $(id);
      if (el.tagName === "SELECT") el.value = id === "f-exchange" ? "all" : el.value;
      else el.value = "";
    });
    $("f-exchange").value = "all";
    state.page = 1;
    state.sort_by = "trade_date";
    state.sort_dir = "desc";
    load();
  });

  ["f-product", "f-participant", "f-broker", "f-delivery", "f-amount-min", "f-amount-max"].forEach((id) => {
    $(id).addEventListener("input", debounced);
  });
  ["f-exchange", "f-date-from", "f-date-to"].forEach((id) => {
    $(id).addEventListener("change", reloadFromStart);
  });

  $("f-per-page").addEventListener("change", () => {
    state.per_page = Number($("f-per-page").value);
    reloadFromStart();
  });
  $("btn-prev").addEventListener("click", () => {
    if (state.page > 1) {
      state.page -= 1;
      load();
    }
  });
  $("btn-next").addEventListener("click", () => {
    state.page += 1;
    load();
  });

  document.querySelectorAll("th[data-sort]").forEach((th) => {
    th.addEventListener("click", () => {
      const key = th.dataset.sort;
      if (state.sort_by === key) {
        state.sort_dir = state.sort_dir === "asc" ? "desc" : "asc";
      } else {
        state.sort_by = key;
        state.sort_dir = key === "trade_date" ? "desc" : "asc";
      }
      reloadFromStart();
    });
  });

  load();
})();
