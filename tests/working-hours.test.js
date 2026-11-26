// @vitest-environment jsdom

import { afterEach, describe, expect, it, vi } from "vitest";
import { loadContentScript } from "./support/load-extension-script.js";

afterEach(() => {
  delete globalThis.__MYTE_TEST_MODE__;
  delete globalThis.__MYTE_DISABLE_AUTO_INIT__;
  delete globalThis.__MYTE_TEST_API__;
  delete globalThis.chrome;
  document.body.innerHTML = "";
});

function timeCell(col, label) {
  const opts = (n) =>
    `<option value="-1"></option>` +
    Array.from({ length: n }, (_, i) => `<option value="${i}">${i}</option>`).join("");
  return `<div col-id="${col}">
    <select aria-label="${label} hours">${opts(24)}</select>
    <select aria-label="${label} minutes">${opts(60)}</select></div>`;
}

function rowHtml(date, withPlus) {
  return `<div role="row" class="ag-row">
    <div col-id="dateTime">${date}</div>
    ${timeCell("workStartTime", "Work Start Time")}
    ${timeCell("workEndTime", "Work End Time")}
    ${timeCell("mealStartTime", "Break Start Time")}
    ${timeCell("mealEndTime", "Break End Time")}
    <div col-id="0">${withPlus ? '<button aria-label="Add new row" aria-disabled="false"></button>' : ""}</div>
  </div>`;
}

function buildGrid() {
  document.body.innerHTML = `<myte-popup-template id="punch-clock-popup">
    <div id="workingHoursPunchClockGrid">
      ${["Mon, 11/16", "Tue, 11/17", "Fri, 11/20", "Sat, 11/21"].map((d) => rowHtml(d, true)).join("")}
    </div></myte-popup-template>`;
  const grid = document.querySelector("#workingHoursPunchClockGrid");
  const renumber = () =>
    grid.querySelectorAll(".ag-row").forEach((r, i) => r.setAttribute("row-index", String(i)));
  renumber();
  grid.addEventListener("click", (e) => {
    const btn = e.target.closest('button[aria-label="Add new row"]');
    if (!btn) return;
    const row = btn.closest(".ag-row");
    row.insertAdjacentHTML("afterend", rowHtml("", false));
    renumber();
  });
}

const val = (row, col, kind) =>
  row.querySelector(`[col-id="${col}"] select[aria-label$="${kind}"]`).value;

describe("working hours dialog", () => {
  it("parses ranges", async () => {
    const { api } = await loadContentScript();
    expect(api.parseTimeRange("08:00-14:30")).toEqual({ startH: 8, startM: 0, endH: 14, endM: 30 });
    expect(api.parseTimeRange("25:00-14:00")).toBeNull();
    expect(api.parseTimeRange("")).toBeNull();
  });

  it("fills Mon-Thu with break and second row, Friday single row", async () => {
    const { api } = await loadContentScript();
    buildGrid();

    const result = await api.fillWorkingHoursDialog(api.state.config);
    expect(result.errors).toBe(0);

    const rows = [...document.querySelectorAll(".ag-row")];
    // Mon, Mon+, Tue, Tue+, Fri, Sat
    expect(rows).toHaveLength(6);
    expect(val(rows[0], "workStartTime", "hours")).toBe("8");
    expect(val(rows[0], "workEndTime", "hours")).toBe("14");
    expect(val(rows[0], "mealStartTime", "hours")).toBe("14");
    expect(val(rows[0], "mealEndTime", "hours")).toBe("15");
    expect(val(rows[1], "workStartTime", "hours")).toBe("15");
    expect(val(rows[1], "workEndTime", "hours")).toBe("17");
    expect(val(rows[1], "mealStartTime", "hours")).toBe("-1");
    expect(val(rows[2], "workStartTime", "hours")).toBe("8");
    expect(val(rows[3], "workEndTime", "hours")).toBe("17");
    expect(val(rows[4], "workEndTime", "hours")).toBe("15");
    expect(val(rows[4], "mealStartTime", "hours")).toBe("-1");
    expect(val(rows[5], "workStartTime", "hours")).toBe("-1"); // Saturday untouched
  });

  it("warns when the dialog is closed", async () => {
    const { api } = await loadContentScript();
    const result = await api.fillWorkingHoursDialog(api.state.config);
    expect(result.errors).toBe(1);
  });
});
