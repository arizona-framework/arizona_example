/* global require, jest, beforeAll, afterAll, beforeEach, afterEach, describe, test, expect */
const { setTimeout: forTimeout } = require("node:timers/promises");
const puppeteer = require("puppeteer");

// Increase Jest timeout for Puppeteer tests
jest.setTimeout(30000); // 30 seconds

describe("Counter Test", () => {
  let browser;
  let page;

  beforeAll(async () => {
    // Launch the browser before all tests
    browser = await puppeteer.launch({
      args: ["--no-sandbox", "--disable-setuid-sandbox"],
    });
  });

  afterAll(async () => {
    // Close the browser after all tests
    await browser.close();
  });

  beforeEach(async () => {
    // Create a new page for each test
    page = await browser.newPage();
  });

  afterEach(async () => {
    // Close the page after each test
    await page.close();
  });

  test("should increment 1", async () => {
    await page.goto("http://localhost:8080");

    // Test the first counter
    let spanSelector = "#counter0 span";
    let btnSelector = "#counter0 button";
    let initialValue = 0;
    await expectCount(page, spanSelector, btnSelector, initialValue);

    // Test the second counter
    spanSelector = "#counter10 span";
    btnSelector = "#counter10 button";
    initialValue = 10;
    await expectCount(page, spanSelector, btnSelector, initialValue);
  });
});

async function expectCount(page, spanSelector, btnSelector, initialValue) {
  // Get initial count
  let count = await page.$eval(spanSelector, (span) => {
    return parseInt(span.innerText);
  });
  expect(count).toBe(initialValue);

  // Click the button and wait for the count to update
  await page.click(btnSelector);
  await forTimeout(250); // Wait for the count to increment

  // Get updated count
  count = await page.$eval(spanSelector, (span) => {
    return parseInt(span.innerText);
  });
  expect(count).toBe(initialValue + 1);
}
