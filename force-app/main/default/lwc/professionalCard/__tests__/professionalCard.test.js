import { createElement } from "lwc";
import ProfessionalCard from "c/professionalCard";
import getReviewsByProfessionalName from "@salesforce/apex/ProfessionalsController.getReviewsByProfessionalName";
import { setImmediate } from "timers";
const mockData = require("./mockData/reviewMockData.json");

jest.mock(
  "@salesforce/apex/ProfessionalsController.getReviewsByProfessionalName",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

describe("c-professional-card", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  beforeEach(() => {
    // Arrange
    const element = createElement("c-professional-card", {
      is: ProfessionalCard
    });
    element.professionalData = {
      Name: "Test Name",
      Phone__c: "5492112121"
    };
    // Act
    document.body.appendChild(element);
  });

  it("wire apex method", () => {
    // Arrange
    const element = createElement("c-professional-card", {
      is: ProfessionalCard
    });
    element.professionalData = {
      Name: "Test Name",
      Phone__c: "5492112121"
    };
    // Act
    document.body.appendChild(element);

    getReviewsByProfessionalName.emit(mockData);
    return new Promise(setImmediate).then(() => {
      const reviewsArray = Array.from(
        element.shadowRoot.querySelectorAll("c-review-card")
      );
      expect(reviewsArray.length).toBe(2);
      const valoracionArray = reviewsArray.map(
        (review) =>
          review.shadowRoot.querySelector(".slds-m-vertical_small").textContent
      );
      expect(valoracionArray).toStrictEqual(["Muy bueno", "Muy malo"]);
    });
  });

  it("elements in the card", () => {
    // Arrange
    const element = createElement("c-professional-card", {
      is: ProfessionalCard
    });
    element.professionalData = {
      Name: "Test Name",
      Phone__c: "5492112121"
    };
    // Act
    document.body.appendChild(element);

    getReviewsByProfessionalName.emit(mockData);
    return new Promise(setImmediate).then(() => {
      const valoracionText = element.shadowRoot.querySelector(".inline");
      expect(valoracionText.textContent).toBe("Valoracion general:  3.0  ");
      const quantReviews = element.shadowRoot.querySelector(".pQuantReviews");
      expect(quantReviews.textContent).toBe("(2 Opiniones)");
    });
  });
});
