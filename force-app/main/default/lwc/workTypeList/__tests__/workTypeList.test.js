import { createElement } from "lwc";
import WorkTypeList from "c/workTypeList";
import getWorkTypesGroup from "@salesforce/apex/ProfessionalsController.getWorkTypesGroup";
import { setImmediate } from "timers";
const mockWorkTypeGroups = require("./mockData/workTypesMock.json");

jest.mock(
  "@salesforce/apex/ProfessionalsController.getWorkTypesGroup",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

describe("c-work-type-list", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("wire apex method", () => {
    // Arrange
    const element = createElement("c-work-type-list", {
      is: WorkTypeList
    });

    // Act
    document.body.appendChild(element);

    // Assert
    // const div = element.shadowRoot.querySelector('div');
    expect(element).not.toBe(null);

    getWorkTypesGroup.emit(mockWorkTypeGroups);

    return new Promise(setImmediate).then(() => {
      const workTypeCards = element.shadowRoot.querySelectorAll(
        "lightning-accordion-section"
      );
      expect(workTypeCards.length).toBe(5);
    });
  });
});
