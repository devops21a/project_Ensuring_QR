# #!/usr/bin/env python
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.utils import ChromeType
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.by import By
import logging


def login(user, password):
    # Create and configure logger
    logging.basicConfig(filename="login_log.log",
                            format='%(asctime)s %(message)s',
                            filemode='w')
    # Creating an object
    logger = logging.getLogger()
    options = ChromeOptions()
    options.add_argument("--headless")
    #driver = webdriver.Chrome(executable_path="/usr/local/bin/chromedriver", options=options)
    #driver = webdriver.Chrome(ChromeDriverManager(version="87.0.4280.88").install())
    driver = webdriver.Chrome(ChromeDriverManager(version="87.0.4280.88", chrome_type=ChromeType.CHROMIUM).install())
    # Setting the threshold of logger to DEBUG
    logger.setLevel(logging.DEBUG)
    print('Starting the browser...')
    logger.debug('Starting the browser...')
    # --uncomment when running in Azure DevOps.
    
    options.add_argument("--headless")
    
    print('Browser started successfully. Navigating to the demo page to login.')
    logger.debug('Browser started successfully. Navigating to the demo page to login.')
    # go to the page
    driver.get('https://www.saucedemo.com/')

    myuser = driver.find_element_by_id("user-name")
    mypassword = driver.find_element_by_id("password")
    myuser.send_keys(user)
    mypassword.send_keys(password)
    driver.find_element_by_id("login-button").click()
    if WebDriverWait(driver, 5).until(EC.presence_of_element_located((By.ID, "inventory_container"))):
        print('--------------------------------------------------------------------')
        print('The Login was successful by the user name: ' + user)
        print('--------------------------------------------------------------------')
        logger.debug('The Login was successful by the user name: ' + user)
    else:
        print('Your login was unsuccessful')
        logger.debug('Your login was unsuccessful')
        driver.close()
    # List of inventory
    invenrotyList = driver.find_elements_by_class_name("inventory_list")
    # List of items
    itemList = driver.find_elements_by_class_name("inventory_item_name")
    # List of add-buttons
    btnAddList = driver.find_elements_by_css_selector("button[class='btn_primary btn_inventory']")
    # List of remove-buttons
    btnRemoveList = driver.find_elements_by_css_selector("button[class='btn_secondary btn_inventory']")

    # adding the products
    for inventory in invenrotyList:
        for item in itemList:
            print("Adding " + item.text + " to cart")
            logger.debug("Adding " + item.text + " to cart")
        for btn in btnAddList:
            btn.click()

    print('----------------------------------')
    print('All the products are added to cart')
    logger.debug('All the products are added to cart')
    print('----------------------------------------------------')
    ## removing the products
    for inventory in invenrotyList:
        for item in itemList:
            print("Removing " + item.text + " from cart")
            logger.debug("Removing " + item.text + " from cart")
        for btn in btnRemoveList:
            btn.click()
    print('----------------------------------------------------')
    print('All products are removed from cart')
    logger.debug('All products are removed from cart')
    driver.close()

login('standard_user', 'secret_sauce')



