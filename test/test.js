/* global require */
async function forCurCount(page, spanId) {
  const count = await page.$eval(spanId, (span) => span.innerText);
  console.log(`${spanId} has value ${count}.`);
  return parseInt(count);
}

async function forNewCount(page, spanId, value0, timeout) {
  await page.waitForFunction(
    (selector, value) => {
      console.log(`${value}`);
      return window.document.querySelector(selector).innerText === `${value}`;
    },
    { timeout: timeout },
    spanId,
    value0,
  );
}

async function btnClick(page, btnId) {
  console.log(`Clicking ${btnId}...`);
  await page.click(btnId);
}

async function launchAt(location) {
  const browser = await require("puppeteer").launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
  });
  const page = await browser.newPage();
  await page.goto(location);
  return [browser, page];
}

async function teardown(browser) {
  await browser.close();
}

(async () => {
  const location = "http://localhost:8080";
  const spanId = "#counter span";
  const btnId = "#counter button";
  let count;

  const [browser, page] = await launchAt(location);

  count = await forCurCount(page, spanId);
  await btnClick(page, btnId);
  // fail if count isn't incremented by 1
  await forNewCount(page, spanId, count + 0, 1250);
  await forCurCount(page, spanId);

  await teardown(browser);
})();
