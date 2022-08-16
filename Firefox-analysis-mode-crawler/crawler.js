const puppeteer = require('puppeteer');
const fs = require("fs");
const { parse } = require("csv-parse");

const firefoxOptions = {
    headless: false,
    product: 'firefox',
};

const sites = [];
fs.createReadStream("sites.csv")
  .pipe(parse({ delimiter: ",", from_line: 2 }))
  .on("data", function (row) {
    sites.push(row[0])
  })
  .on("error", function (error) {
    console.log(error.message);
  });


(async () => {
    const browser = await puppeteer.launch(firefoxOptions);
    const page = await browser.newPage();
    // Allow time to load the extension
    await new Promise(resolve => setTimeout(resolve, 60000));

    for (let site in sites) {
        console.log(sites[site]);

        try {
          await page.goto(sites[site], { waitUntil: "domcontentloaded" });
          console.log("Navigated!");
        } catch {
          console.log("Site loading went wrong");
        } 
        
        await new Promise(resolve => setTimeout(resolve, 10000));

        // Some sites put the crawler in a text box. Clicking on a non-hyperlink element solves the problem. 
        try {
          await Promise.race([page.keyboard.down('Shift'), new Promise(resolve => setTimeout(resolve, 5000))]);
          await Promise.race([page.keyboard.down('Tab'), new Promise(resolve => setTimeout(resolve, 5000))]);
          console.log('Clicked')
        } catch {
          console.log("Not clicked")
        }

        await new Promise(resolve => setTimeout(resolve, 10000));

        // Promise.race sets time limit for page.keyboard.down to resolve the issue that page.keyboard.down is never rejected or resolved on some sites
        await Promise.race([page.keyboard.down('Alt'), new Promise(resolve => setTimeout(resolve, 5000))]);
        await Promise.race([page.keyboard.down('Shift'), new Promise(resolve => setTimeout(resolve, 5000))]);
        await Promise.race([page.keyboard.down('KeyA'), new Promise(resolve => setTimeout(resolve, 5000))]);
  
        // Allow the site to load after analysis is triggered
        await new Promise(resolve => setTimeout(resolve, 10000));

        try {
          await Promise.race([page.keyboard.down('Shift'), new Promise(resolve => setTimeout(resolve, 5000))]);
          await Promise.race([page.keyboard.down('Tab'), new Promise(resolve => setTimeout(resolve, 5000))]);
          console.log('Clicked')
        } catch {
          console.log("Not clicked")
        }

        await new Promise(resolve => setTimeout(resolve, 10000));
        await Promise.race([page.keyboard.down('Shift'), new Promise(resolve => setTimeout(resolve, 5000))]);
        await Promise.race([page.keyboard.down('Alt'), new Promise(resolve => setTimeout(resolve, 5000))]);
        await Promise.race([page.keyboard.down('KeyS'), new Promise(resolve => setTimeout(resolve, 5000))]);
        
        await new Promise(resolve => setTimeout(resolve, 10000));
      
        console.log("testing done");
    }
    console.log("---------------- ALL TESTING DONE ----------------")
})();

