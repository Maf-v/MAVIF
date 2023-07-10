import { createElement } from "lwc";
import WorkTypeCard from "c/workTypeCard";
import { setImmediate } from "timers";
import getProfessionalsByType from "@salesforce/apex/ProfessionalsController.getProfessionalsByType";
const professionalsMockData = require("./mockData/professionalsMock.json");

jest.mock(
  "@salesforce/apex/ProfessionalsController.getProfessionalsByType",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

describe("c-work-type-card", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("TODO: test case generated by CLI command, please fill in test logic", () => {
    // Arrange
    const element = createElement("c-work-type-card", {
      is: WorkTypeCard
    });

    // Act
    document.body.appendChild(element);

    // Assert
    // const div = element.shadowRoot.querySelector('div');
    expect(element).not.toBe(null);

    getProfessionalsByType.emit(professionalsMockData);

    return new Promise(setImmediate).then(() => {
      const professionalCards = element.shadowRoot.querySelectorAll(
        "lightning-layout-item"
      );
      expect(professionalCards.length).toBe(2);
    });
  });
});
